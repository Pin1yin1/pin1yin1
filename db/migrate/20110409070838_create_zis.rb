class CreateZis < ActiveRecord::Migration
  def self.up
    create_table :zi, :options => "default charset=utf8" do |t|
      t.column :character, "char(1)", :null => false
      t.column :strokes, :tinyint, :null => false
      t.column :radical, :tinyint, :null => false
      t.column :strokes_after_radical, :tinyint, :null => false
      t.column :is_radical, :tinyint, :null => false
      t.column :phonetic, :tinyint, :null => false
      t.column :is_phonetic, :tinyint, :null => false
      t.column :active, :boolean, :null => false, :default => false
    end
    add_index :zi, :strokes
    add_index :zi, :radical
    add_index :zi, :strokes_after_radical
    add_index :zi, [:radical,:strokes_after_radical]
    add_index :zi, :is_radical
    add_index :zi, :phonetic
    add_index :zi, :is_phonetic
    add_index :zi, :active
  end

  def self.down
    drop_table :zi
  end
end
