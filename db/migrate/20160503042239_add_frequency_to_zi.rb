class AddFrequencyToZi < ActiveRecord::Migration
  def change
    add_column :zi, :frequency, 'tinyint unsigned', :null => false
  end
end
