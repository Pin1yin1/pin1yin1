namespace :bopomofo do
  desc 'Regenerate app/assets/javascripts/bopomofo.js from data/bopomofo.dat'
  task :generate_js => :environment do
    js_path = Rails.root.join('app/assets/javascripts/bopomofo.js')

    File.open(js_path, 'w') do |js|
      js.puts('var bopomofo = {')

      File.foreach(Rails.root.join('data/bopomofo.dat')) do |line|
        line =~ /(.*) (.*)/
        zhuyin = $1
        pinyin = $2

        (1..5).each do |tone|
          pinyin_ascii_tone = pinyin + tone.to_s
          pinyin_uni = Syllable.pinyin_ascii_to_pinyin_uni(pinyin_ascii_tone)
          js.puts("  \"#{pinyin_ascii_tone}\" : { \"pinyin\" : \"#{pinyin_uni}\", \"zhuyin\" : \"#{zhuyin}\" }, ")
        end
      end

      (1..5).each do |tone|
        c = Syllable.pinyin_ascii_to_pinyin_uni(tone.to_s)
        pinyin_c = (tone == 5 ? ' ' : c)
        zhuyin_c = (tone == 1 ? ' ' : c)
        js.puts("  \"#{tone}\" : { \"pinyin\" : \"#{pinyin_c}\", \"zhuyin\" : \"#{zhuyin_c}\" }, ")
      end

      js.puts('}')
    end
  end
end
