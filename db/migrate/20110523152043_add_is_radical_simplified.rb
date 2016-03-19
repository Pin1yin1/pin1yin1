class AddIsRadicalSimplified < ActiveRecord::Migration
  def self.up
    add_column :zi, :is_radical_simplified, "tinyint unsigned", :null =>false
    add_index :zi, :is_radical_simplified
  end

  def self.down
    remove_column :zi, :is_radical_simplified
  end
end
