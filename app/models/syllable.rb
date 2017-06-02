# encoding: UTF-8
class Syllable < ApplicationRecord
  @@accents = {
    "a" => ['ā','á','ǎ','à','a'],
    "e" => ['ē','é','ě','è','e'],
    "i" => ['ī','í','ǐ','ì','i'],
    "o" => ['ō','ó','ǒ','ò','o'],
    "u" => ['ū','ú','ǔ','ù','u'],
    "v" => ['ǖ','ǘ','ǚ','ǜ','ü'],
    "m" => ['m̄','ḿ','m̌','m̀','m'],
    ""  => ['¯','´','ˇ','`','˙'],
  }

  def self.pinyin_ascii_to_pinyin_uni(pinyin_ascii)
    if pinyin_ascii =~ /^m([1-5])/
      tone = $1.to_i
      return @@accents["m"][tone-1]
    end

    if pinyin_ascii =~ /\A[1-5]\Z/
      tone = pinyin_ascii.to_i
      return @@accents[""][tone-1]
    end

    pinyin_ascii =~ /^(.*?)([aeiouv]+)(.*)([1-5])$/
    initial = $1.to_s
    vowel = $2
    final = $3.to_s
    tone = $4.to_i
    pre = ""
    post = ""
    if vowel.length > 1
      if vowel =~ /([iuv])(.)(.*)/
        pre = $1
        vowel = $2
        post = $3
      elsif vowel =~ /(.)(.*)/
        vowel = $1
        post = $2
      else
        raise "couldn't parse vowel of #{pinyin_ascii} (#{initial} #{vowel} #{final} #{tone})"
      end
    end

    vowel = @@accents[vowel][tone-1]
    if pre == 'v'
      pre = 'ü'
    end

    return initial+pre+vowel+post+final
  end
end
