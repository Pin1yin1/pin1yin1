Syllable.connection.execute 'alter table syllables disable keys'

file = File.open(Rails.root+"data/bopomofo.dat")

Syllable.where(:active => false).delete_all
while bopomofo = file.gets
  bopomofo =~ /(.*) (.*)/
  zhuyin = $1
  pinyin = $2

  (1..5).each do |tone|
    syllable = Syllable.new
    syllable.tone = tone
    syllable.pinyin_ascii = pinyin
    syllable.pinyin_ascii_tone = pinyin+tone.to_s
    syllable.pinyin = Syllable.pinyin_ascii_to_pinyin_uni(pinyin+tone.to_s)
    syllable.zhuyin = zhuyin
    syllable.zhuyin_tone = "" # TODO
    syllable.save!
  end
end

Syllable.connection.execute "update syllables set active = !active"
Syllable.where(:active => false).delete_all
