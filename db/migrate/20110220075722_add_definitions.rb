class AddDefinitions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :definitions, :options => "default charset=utf8" do |t|
      t.column :characters_simplified, :string, :null => false
      t.column :characters_traditional, :string, :null => false
      t.column :pinyin_ascii_tone, :string, :null => false
      t.column :pinyin_ascii, :string, :null => false
      t.column :english, :string, :null => false
      t.column :active, :boolean, :null => false, :default => false
    end
    add_index :definitions, :characters_traditional
    add_index :definitions, :characters_simplified
    add_index :definitions, :pinyin_ascii_tone
    add_index :definitions, :pinyin_ascii
  end

  def self.down
    drop_table :definitions
  end
end
