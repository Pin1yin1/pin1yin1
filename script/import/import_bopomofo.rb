Syllable.connection.execute 'alter table syllables disable keys'

file = File.open(Rails.root+"data/bopomofo.dat")
js = File.open(Rails.root+"app/assets/javascripts/bopomofo.js","w")
js.puts("var bopomofo = {")

Syllable.delete_all(:active => false)
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
    js.puts("  \"#{syllable.pinyin_ascii_tone}\" : { \"pinyin\" : \"#{syllable.pinyin}\", \"zhuyin\" : \"#{syllable.zhuyin}\" }, ")
  end
end

(1..5).each do |tone|
  c = Syllable.pinyin_ascii_to_pinyin_uni(tone.to_s)
  pinyin_c = (tone == 5 ? " " : c)
  zhuyin_c = (tone == 1 ? " " : c)
  js.puts("  \"#{tone}\" : { \"pinyin\" : \"#{pinyin_c}\", \"zhuyin\" : \"#{zhuyin_c}\" }, ")
end

js.puts("}")
js.close
Syllable.connection.execute "update syllables set active = !active"
Syllable.delete_all :active => false
