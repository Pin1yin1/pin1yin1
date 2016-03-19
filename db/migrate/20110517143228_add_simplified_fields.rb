class AddSimplifiedFields < ActiveRecord::Migration
  def self.up
    add_column :zi, :simplified_zi_id, :integer, :default => nil
    add_column :zi, :is_simplified, :boolean, :default => false, :null => false
    add_column :zi, :is_traditional, :boolean, :default => false, :null => false
    add_index :zi, :simplified_zi_id
    add_index :zi, :is_simplified
    add_index :zi, :is_traditional
  end

  def self.down
    remove_column :zi, :simplified_zi_id
    remove_column :zi, :is_simplified
    remove_column :zi, :is_traditional
  end
end
