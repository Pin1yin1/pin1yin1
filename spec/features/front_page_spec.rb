# -*- coding: utf-8 -*-
require 'spec_helper.rb'

feature "Front page", js: true do
  # something about transactions is possibly screwing it up if we don't do :all
  before do
    create :definition, characters_simplified: "你好", characters_traditional: "你好", english: "hello", pinyin_ascii: 'ni hao', pinyin_ascii_tone: 'ni3 hao3'
    create :definition, characters_simplified: "你", characters_traditional: "你", english: "you", pinyin_ascii: 'ni', pinyin_ascii_tone: 'ni3'
    create :definition, characters_simplified: "好", characters_traditional: "好", english: "good", pinyin_ascii: 'hao', pinyin_ascii_tone: 'hao3'
  end

  specify do
    visit "/"
    expect(page).to have_selector("a", text: "Pinyin converter")
    fill_in "input", with: "你好"

    click_button "Convert"
    expect(page).to have_selector("a", text: "你")
    expect(page).to have_selector("a", text: "好")
    expect(page).to have_selector("td", text: "nǐ")
    expect(page).to have_selector("td", text: "hǎo")
    expect(page).to have_selector("p", text: "hello")

    expect(page).to have_selector("textarea", text: "nǐ hǎo")

    fill_in "input", with: "你好好"
    click_button "Convert"
    expect(page).to have_selector("textarea", text: "nǐ hǎo hǎo")

    select "pin1yin1", from: "romanization"
    expect(page).to have_selector("textarea", text: "ni3 hao3 hao3")

    select "ㄓㄨㄧㄣ", from: "romanization"
    expect(page).to have_selector("textarea", text: "ㄋㄧˇ ㄏㄠˇ ㄏㄠˇ")

    select "pīnyīn", from: "romanization"
    fill_in "input", with: "你好你\n好"
    click_button "Convert"

    expect(page).to have_selector("textarea", text: "nǐ hǎo nǐ hǎo")

    # get raw html to check newline
    html = page.evaluate_script("document.getElementById('pinyin_text').innerHTML")
    expect(html).to eq "nǐ hǎo nǐ\nhǎo\n"
  end
end
