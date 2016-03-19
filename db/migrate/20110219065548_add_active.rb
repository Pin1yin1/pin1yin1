class AddActive < ActiveRecord::Migration
  def self.up
    add_column :syllables, :active, :boolean, :null => false, :default => false 
  end

  def self.down
    remove_column :syllables, :active
  end
end
