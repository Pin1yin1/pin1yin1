class AddActive < ActiveRecord::Migration[4.2]
  def self.up
    add_column :syllables, :active, :boolean, :null => false, :default => false 
  end

  def self.down
    remove_column :syllables, :active
  end
end
