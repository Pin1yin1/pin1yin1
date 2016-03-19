# encoding: UTF-8
class Definition < ActiveRecord::Base
  acts_as_indexed :fields => [:english]

  def english_abbreviated
    pieces = english.split /;/
    i=1
    ret = pieces[0]
    while(i < pieces.length && ret.length)
      if ret.length + 1 + pieces[i].length < 20
        ret += ";"+pieces[i]
      end
      i += 1
    end
    return ret
  end

  # returns a hash
  # :characters_simplified
  # :characters_traditional
  # :pinyin_ascii_tone => array of pinyin (ascii) with tones for each character
  # :english => array of english definition strings
  # :english_character_count => number of characters that each definition applies to
  def self.convert(s)
    i = 0
    ret = {:pinyin_ascii_tone => [], :english => [], :english_character_count => [],
    :characters_simplified => "", :characters_traditional => ""}

    while i < s.length
      c = s[i]
      
      # skip non-chinese characters
      if (c.ord < 0x2E80 || c.ord > 0xD7FF) && (c.ord < 0x20000 || c.ord > 0x2FA1D)
        ret[:characters_simplified] += c
        ret[:characters_traditional] += c
        ret[:pinyin_ascii_tone] << ""
        ret[:english] << ""
        ret[:english_character_count] << 1
        i += 1
        next
      end

      list = Definition.where("characters_simplified like ? or characters_traditional like ?", c+"%", c+"%").
        order("length(characters_simplified) desc, \"primary\" desc")
      d = nil # default
      list.each do |definition|
        simplified = definition.characters_simplified
        traditional = definition.characters_traditional
        substr = s[i..i+simplified.length-1]
        if substr == simplified || substr == traditional
          d = definition # found the longest one
          break
        end
      end

      if !d # no good definition
        ret[:characters_simplified] += c
        ret[:characters_traditional] += c
        ret[:pinyin_ascii_tone] << ""
        ret[:english] << ""
        ret[:english_character_count] << 1        
        i += 1
      else
        d.pinyin_ascii_tone.split(/ /).each do |syllable|
          ret[:pinyin_ascii_tone] << syllable
        end
        ret[:characters_simplified] += d.characters_simplified
        ret[:characters_traditional] += d.characters_traditional
        ret[:english] << d.english_abbreviated
        ret[:english_character_count] << d.characters_simplified.length
        i += d.characters_simplified.length
      end
    end

    Definition.do_standard_tone_shifts(ret)

    return ret
  end

  private

  def self.do_standard_tone_shifts(ret)
    (ret[:characters_simplified].length-2).downto(0) do |i|
      char = ret[:characters_simplified][i]
      next_tone = ret[:pinyin_ascii_tone][i+1][-1]

      if char == '不' && next_tone == "4"
        ret[:pinyin_ascii_tone][i].sub!('4','2')
      end
    end
  end
end
