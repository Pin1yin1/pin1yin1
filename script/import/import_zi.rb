# -*- coding: utf-8 -*-
Zi.connection.execute 'alter table zi disable keys'

Zi.where(:active => false).delete_all

ZI_HASH = {} # indexed by character

result = Zi.connection.execute 'select max(id) from zi'
result.each do |row|
  $id = (row[0] || 0)+1
end

def find_or_create(hex_code)
  if hex_code.length > 4
    return nil # skip characters outside of the BMP
  end

  character = [hex_code.hex].pack("U")

  if !ZI_HASH[character] 
    ZI_HASH[character] =
      Zi.new(:character => character, :strokes => 0, :radical => 0, :strokes_after_radical => 0, :is_radical => 0, :is_radical_simplified => 0, :phonetic => 0, :is_phonetic => 0, :active => false)
    ZI_HASH[character].id = $id # this must be done *after* new
    $id += 1
  end
  return ZI_HASH[character]
end

class FileReader
  def self.open(name)
    return FileReader.new(name)
  end

  def initialize(name)
    @filename = name
    @file = File.open name
    @line_num = 0
  end

  def gets
    while true
      @line_num += 1
      s = @file.gets
      return nil if !s
      next if (s =~ /\A#/)
      next if (s =~ /\A\s*\Z/)
      return s
    end
  end

  def raise(s)
    Kernel.raise "#{@filename}:#{@line_num}: #{s}"
  end

  def close
    @file.close
  end

  def parse_entry(line)
    if !(line =~ /\AU\+([0-9A-F]{4,5})\s+([a-zA-Z0-9_]+)\s+(.*)\Z/)
      self.raise "could not parse"
    end
    zi = find_or_create($1)
    key = $2
    value = $3
    return [zi,key,value]
  end
end

# import RAdical/Stroke count data
file = FileReader.open Rails.root+"data/Unihan_IRGSources.txt"

while line = file.gets
  (zi,key,value) = file.parse_entry(line)
  next if !zi
  if key == "kRSUnicode"
    file.raise "bad kRSUnicode" if !(value =~ /([0-9]+)(\'?)\.-?([0-9]+)/)
    zi.radical = $1.to_i
    zi.strokes_after_radical = $3.to_i
  end
end
file.close

# import Radical identities
file = FileReader.open Rails.root+"data/CJKRadicals.txt"
while line = file.gets
  if !(line =~ /([0-9]+)(\'?); ([0-9A-F]+); ([0-9A-F]+)/)
    file.raise "could not parse" 
  end

  zi = find_or_create($4)
  next if !zi

  if $2 == "'"
    # the ' means it is the simplified version of the radical
    zi.is_radical_simplified = $1.to_i
  else
    zi.is_radical = $1.to_i
  end

  # I am not sure that this is a good idea, but it seems reasonable.
  # character 5364 (卤) is supposed to be radical 197 but has 25.5 instead (RuntimeError)
  zi.radical = $1.to_i
  zi.strokes_after_radical = 0
end

def q(s)
  Zi.connection.quote(s)
end

# import dictionary data
file = FileReader.open Rails.root+"data/Unihan_DictionaryLikeData.txt"
while line = file.gets
  (zi,key,value) = file.parse_entry(line)
  next if !zi

  if key == "kTotalStrokes"
    zi.strokes = value.to_i
    file.raise "bad total strokes #{value}" if zi.strokes == 0 
  end
  if key == "kPhonetic"
    zi.phonetic = value.to_i
    file.raise "bad phonetic #{value}" if zi.phonetic == 0 
  end
end

# import variants
file = FileReader.open Rails.root+"data/Unihan_Variants.txt"
while line = file.gets
  (zi,key,value) = file.parse_entry(line)
  next if !zi

  if key == 'kSimplifiedVariant'
    zi2 = find_or_create(value[2..-1])

    # zi2 might not be in the BMP!
    if zi2
      zi.simplified_zi_id = zi2.id
      zi2.is_simplified = true
    end

    zi.is_traditional = true
    zi.is_simplified = false if zi != zi2
  end
end

# Use mappings to big5 and gb character sets to identify more
# simplified and traditional characters.
file = FileReader.open Rails.root+"data/Unihan_OtherMappings.txt"
while line = file.gets
  (zi,key,value) = file.parse_entry(line)
  next if !zi

  if key == "kBigFive"
    zi.is_traditional = true
  elsif key == "kGB0"
    # GB0 corresponds to GB 2312, which is all simplified
    zi.is_simplified = true
  end
end

# get more variant information from cedict
result = Zi.connection.execute 'select characters_traditional,characters_simplified from definitions'
result.each do |row|
  trad = row[0]
  simp = row[1]
  trad.length.times do |i|
    char = trad[i].unpack("U")[0]
    next if !Zi.character_is_chinese(char)
    zi_t = find_or_create("%x"%char)
    next if !zi_t

    char = simp[i].unpack("U")[0]
    next if !Zi.character_is_chinese(char)
    zi_s = find_or_create("%x"%char)
    next if !zi_s

    next if zi_t.simplified_zi_id

    zi_t.simplified_zi_id = zi_s.id
    zi_t.is_traditional = true
    if zi_s != zi_t
      zi_t.is_simplified = false
    end
    zi_s.is_simplified = true
  end
end

# save all zis using a bulk method
sql = nil
i = 0
ZI_HASH.each_value do |zi|
  i += 1
  if !sql
    sql = "insert into zi (id,`character`,strokes,radical,strokes_after_radical,is_radical,is_radical_simplified,phonetic,is_phonetic,simplified_zi_id,is_simplified,is_traditional,active) values ";
  else
    sql += ","
  end

  sql += <<END
(#{zi.id},'#{zi.character}',#{zi.strokes || 'NULL'},#{zi.radical || 'NULL'},#{zi.strokes_after_radical || 'NULL'},#{zi.is_radical || 'NULL'},#{zi.is_radical_simplified || 'NULL'},#{zi.phonetic || 'NULL'},#{zi.is_phonetic || 'NULL'},#{zi.simplified_zi_id || 'NULL'},#{zi.is_simplified ? 1 : 0},#{zi.is_traditional ? 1 : 0},0)
END
  if sql.length > 2000
    Zi.connection.execute(sql)
    sql = nil
    (i).to_s.length.times { print "" }
    print i.to_s
    STDOUT.flush
  end
end

if sql
  Definition.connection.execute(sql)
end

# Do something about zis that are not traditional or simplified
# it looks like they are probably mostly traditional characters.
sql = "update zi set is_traditional = true, is_simplified = false, simplified_zi_id = id where is_traditional = false and is_simplified = false"
Zi.connection.execute(sql)

Zi.connection.execute "update zi set active = !active"
Zi.where(:active => false).delete_all
Zi.connection.execute 'alter table zi enable keys'

              
puts ""
