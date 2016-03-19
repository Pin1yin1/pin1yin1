# -*- coding: utf-8 -*-
require 'spec_helper.rb'

describe Definition do
  # something about transactions is possibly screwing it up if we don't do :all
  before do
    create :definition, characters_simplified: "你好", characters_traditional: "你好", english: "hello", pinyin_ascii: 'ni hao', pinyin_ascii_tone: 'ni3 hao3'
    create :definition, characters_simplified: "你", characters_traditional: "你", english: "you", pinyin_ascii: 'ni', pinyin_ascii_tone: 'ni3'
    create :definition, characters_simplified: "好", characters_traditional: "好", english: "good", pinyin_ascii: 'hao', pinyin_ascii_tone: 'hao3'
    create :definition, characters_simplified: "不", characters_traditional: "不", english: "not", pinyin_ascii: 'bu', pinyin_ascii_tone: 'bu4'
    create :definition, characters_simplified: "辣", characters_traditional: "辣", english: "spicy", pinyin_ascii: 'la', pinyin_ascii_tone: 'la4'
  end

  describe ".convert" do
    it "converts a single character" do
      conversion = Definition.convert("好")
      expect(conversion[:characters_simplified]).to eq "好"
      expect(conversion[:characters_traditional]).to eq "好"
      expect(conversion[:pinyin_ascii_tone]).to eq ["hao3"]
      expect(conversion[:english]).to eq ["good"]
      expect(conversion[:english_character_count]).to eq [1]
    end

    it "converts two characters" do
      conversion = Definition.convert("你好")
      expect(conversion[:characters_simplified]).to eq "你好"
      expect(conversion[:characters_traditional]).to eq "你好"
      expect(conversion[:pinyin_ascii_tone]).to eq ["ni3", "hao3"]
      expect(conversion[:english]).to eq ["hello"]
      expect(conversion[:english_character_count]).to eq [2]
    end

    it "does not transform 不好" do
      conversion = Definition.convert("不好")
      expect(conversion[:pinyin_ascii_tone]).to eq ["bu4", "hao3"]
    end

    it "transforms 不辣" do
      conversion = Definition.convert("不辣")
      expect(conversion[:pinyin_ascii_tone]).to eq ["bu2", "la4"]
      expect(conversion[:english]).to eq ["not", "spicy"]
    end
  end

end
