# -*- coding: utf-8 -*-
require 'spec_helper.rb'

feature 'Dictionary', js: true do
  before do
    [%W(hello           ni3\ hao3  你好),
     %W(ferocious       xiong1     凶),
     %W(Xi-an           xi1\ an1   西安),
     %W(first           xian1      先),
     %W(Western\ Europe xi1\ o1    西欧),
     %W(fake\ word      qi1\ o1\ ne5 ???),
    ].each do |a, b, c, d|
      create :definition, english: a, pinyin_ascii: b.gsub(/\d/,''), pinyin_ascii_tone: b, characters_simplified: c, characters_traditional: c
    end
  end

  specify do
    {
      'nihao' => 'hello',
      'ni3hao3' => 'hello',
      'xian' => 'first',
      'xi an' => 'Xi-an',
      'xio' => 'Western Europe',
      'qione' => 'fake word',
      'xiong' => 'ferocious',
    }.each_pair do |pinyin, english|
      visit '/dict'
      fill_in 'Enter pinyin', with: pinyin
      click_button 'Search by pinyin'
      expect(page).to have_text(english)
    end
  end
end
