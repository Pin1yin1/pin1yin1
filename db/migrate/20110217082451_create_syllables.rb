class CreateSyllables < ActiveRecord::Migration
  def self.up
    create_table :syllables, :options => "default charset=utf8" do |t|
      t.integer :tone, :null => false, :limit => 1
      t.string :pinyin, :null=> false, :limit => 6
      t.string :pinyin_ascii, :null => false, :limit => 6
      t.string :pinyin_ascii_tone, :null => false, :limit => 7
      t.string :zhuyin, :null => false, :limit => 3
      t.string :zhuyin_tone, :null => false, :limit => 255
    end
  end

  def self.down
    drop_table :syllables
  end
end
