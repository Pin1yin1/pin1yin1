class AddPrimaryDefinition < ActiveRecord::Migration
  def self.up
    add_column :definitions, :primary, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :definitions, :primary
  end
end
