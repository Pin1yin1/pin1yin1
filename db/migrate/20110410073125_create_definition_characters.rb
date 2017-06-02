class CreateDefinitionCharacters < ActiveRecord::Migration[4.2]
  def self.up
    create_table :definition_characters, :options => "default charset=utf8" do |t|
      t.integer :definition_id, :null => false
      t.column :character, 'char(1)', :null => false
      t.column :active, :boolean, :null => false, :default => false
    end
    add_index :definition_characters, :character
  end

  def self.down
    drop_table :definition_characters
  end
end
