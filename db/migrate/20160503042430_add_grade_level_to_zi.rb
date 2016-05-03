class AddGradeLevelToZi < ActiveRecord::Migration
  def change
    add_column :zi, :grade_level, 'tinyint unsigned', :null => false
  end
end
