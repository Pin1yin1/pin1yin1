# -*- coding: utf-8 -*-
Definition.connection.execute 'alter table definitions disable keys'

# cache all valid syllables
valid_syllables = {}
Syllable.all.each do |syllable|
  valid_syllables[syllable.pinyin_ascii_tone] = true
end

# identify the primary pronunciations
primary_pronunciations = {}
file = File.open Rails.root+"data/Unihan_Readings.txt"
while line = file.gets
  next if line[0] == "#"
  next if line !~ /U\+([0-9a-f]+)\s(\S+)\s(.*)/
  hex_code = $1
  key = $2
  value = $3
  next if key != "kMandarin"
  next if hex_code.length > 4 # skip characters outside of the BMP
  character = [hex_code.hex].pack("U")

  if key == "kMandarin"
    p = value.split(/\s/)
    if p.length > 1
      primary_pronunciations[character] = p[0].downcase
    end
  end
end


file = File.open(Rails.root+"data/cedict_ts.u8")
Definition.delete_all(:active => false)
line_num = 0
sql = nil
while line = file.gets
  line_num += 1
  next if (line =~ /\A#/)
  next if !(line =~ /(\S+) (\S+) \[(.*?)\] \/(.*)\//)
  traditional = $1
  simplified = $2
  raw_pinyin = $3
  englishes = $4.split /\//

  raw_pinyin.gsub!(/u:/,"v")
  pinyin_ascii_tone = ""

  syllables = raw_pinyin.split(/ /).collect do |syllable|
    syllable = "er5" if syllable == "r5"
    syllable.downcase! if syllable =~ /[A-Z].*[0-9]/ # proper nouns are capitalized in cedict

    if syllable =~ /^[A-Za-z]$/ || # skip single letters used to represent the english alphabet
      syllable =~ /[,·]/ || # punctuation
      syllable == "xx5" || # no pronunciation
      syllable == "ging1" # no pronunciation
      "-"
    else
      raise "line #{line_num}: no such syllable '#{syllable}'" if !valid_syllables[syllable]
      syllable
    end
  end
  $stderr.puts "#{raw_pinyin} has different length from #{simplified}" if syllables.length != simplified.length

  pinyin_ascii_tone = syllables.join(" ")
  pinyin_ascii_tone.chomp!(" ")
  pinyin_ascii = pinyin_ascii_tone.gsub(/[0-9]/,"")

  englishes.collect! do |english|
    english.gsub(/\[[^\]]*\]/,"") # remove distracting pinyin pronunciations
  end
  englishes = englishes.delete_if do |english|
    english =~ /\ACL:/ # remove measure words
  end

  primary = "0"
  if simplified.length == 1
    if (pinyin_ascii_tone == primary_pronunciations[simplified] ||
        pinyin_ascii_tone == primary_pronunciations[traditional])
      primary = "1"
    end
  end

  if !sql
    sql = "insert into definitions (characters_simplified,characters_traditional,pinyin_ascii_tone,pinyin_ascii,english,active,`primary`) values ";
  else
    sql += ","
  end

  sql += <<END
(#{Definition.connection.quote(simplified)}, #{Definition.connection.quote(traditional)},
 #{Definition.connection.quote(pinyin_ascii_tone)}, #{Definition.connection.quote(pinyin_ascii)},
 #{Definition.connection.quote(englishes.join("; ")[0..254])}, 0, #{primary})
END

  if sql.length > 10000
    Definition.connection.execute(sql)
    sql = nil
    (line_num-1).to_s.length.times { print "" }
    print line_num.to_s
    STDOUT.flush
  end
end

if sql
  Definition.connection.execute(sql)
end

puts ""
Definition.connection.execute "update definitions set active = !active"
Definition.delete_all :active => false
Definition.connection.execute 'alter table definitions enable keys'
