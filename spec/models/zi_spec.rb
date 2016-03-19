require 'spec_helper'

describe Zi do
  context "given the fake zi A" do
    before :all do
      Zi.delete_all
      @zi = Zi.new({character: "A", is_phonetic: false, is_radical: false, is_radical_simplified: false, is_simplified: true, is_traditional: true, phonetic: 0, radical: 0, simplified_zi_id: 0, strokes: 4, strokes_after_radical: 0}, without_protection: true)
      @zi.save!
      @primary_definition = Definition.new({english: "the letter A", characters_simplified: "A", characters_traditional: "A", active: true, pinyin_ascii: '', pinyin_ascii_tone: ''}, without_protection: true)
      @primary_definition.save!
      @primary_definition.characters_simplified.chars.each do |character|
        DefinitionCharacter.new({definition_id: @primary_definition.id, character: character, active: true}, without_protection: true).save!
      end

      @secondary_definition = Definition.new({english: "the string ABC", characters_simplified: "ABC", characters_traditional: "ABC", active: true, pinyin_ascii: '', pinyin_ascii_tone: ''}, without_protection: true)
      @secondary_definition.save!
      @secondary_definition.characters_simplified.chars.each do |character|
        DefinitionCharacter.new({definition_id: @secondary_definition.id, character: character, active: true}, without_protection: true).save!
      end

      @zi.reload
    end

    it "returns the correct primary definition" do
      expect(@zi.primary_definitions).to eq [@primary_definition]
    end

    it "should return the correct secondary definition" do
      expect(@zi.secondary_definitions).to eq [@secondary_definition]
    end

  end
end
