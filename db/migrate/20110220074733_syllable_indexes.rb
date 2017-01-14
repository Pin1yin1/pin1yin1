class SyllableIndexes < ActiveRecord::Migration[4.2]
  def self.up
    change_table :syllables do |t|
      t.index :pinyin_ascii
      t.index [:pinyin_ascii, :pinyin_ascii_tone]
      t.index :pinyin_ascii_tone
      t.index :zhuyin
    end

  end

  def self.down
    change_table :syllables do |t|
      t.remove_index :pinyin_ascii
      t.remove_index [:pinyin_ascii, :pinyin_ascii_tone]
      t.remove_index :pinyin_ascii_tone
      t.remove_index :zhuyin
    end
  end
end
