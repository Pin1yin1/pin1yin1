class Zi < ActiveRecord::Base
  def primary_definitions
    Definition.joins("inner join definition_characters on definition_id=definitions.id and definition_characters.character='#{character}' and definitions.active and definition_characters.active").where("char_length(definitions.characters_simplified) = 1").order("`primary` desc, definitions.pinyin_ascii_tone asc")
  end

  def secondary_definitions
    Definition.joins("inner join definition_characters on definition_id=definitions.id and definition_characters.character='#{character}' and definitions.active and definition_characters.active").where("char_length(definitions.characters_simplified) > 1").order(:pinyin_ascii_tone)
  end

  belongs_to :simplified_zi, :class_name => 'Zi'
  has_many :traditional_zi, :class_name => 'Zi', :foreign_key => 'simplified_zi_id'

  def self.table_name
    "zi"
  end

  def self.active
    where(:active => true)
  end

  def self.find_character(character)
    active.where(:character => character).first
  end

  def self.radical_zi_traditional(radical)
    where(:is_radical => radical).first
  end

  def self.radical_zi_simplified(radical)
    # get the simplified one if it exists, default to the traditional one
    where(:is_radical_simplified => radical).first || radical_zi_traditional(radical)
  end

  def radical_zi_traditional
    Zi.radical_zi_traditional(radical)
  end

  def radical_zi_simplified
    Zi.radical_zi_simplified(radical)
  end

  def self.find_by_radical(radical)
    where(:radical => radical)
  end

  def to_s
    return character
  end

  # given a character number, return true iff it is a chinese character
  def self.character_is_chinese(c)
    (c >= 0x2E80 && c <= 0xD7FF) || (c >= 0x20000 && c <= 0x2FA1D)
  end
end
