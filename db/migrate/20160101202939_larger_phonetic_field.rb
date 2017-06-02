class LargerPhoneticField < ActiveRecord::Migration[4.2]
  def self.up
    change_column :zi, :phonetic, "integer unsigned", :null =>false
    change_column :zi, :is_phonetic, "integer unsigned", :null =>false
  end

  def self.down
    change_column :zi, :phonetic, :tinyint, :null =>false
    change_column :zi, :is_phonetic, :tinyint, :null =>false
  end
end
