class UnsignedRadicals < ActiveRecord::Migration
  def self.up
    change_column :zi, :radical, "tinyint unsigned", :null =>false
    change_column :zi, :is_radical, "tinyint unsigned", :null =>false
  end

  def self.down
    change_column :zi, :radical, :tinyint, :null =>false
    change_column :zi, :is_radical, :tinyint, :null =>false
  end
end
