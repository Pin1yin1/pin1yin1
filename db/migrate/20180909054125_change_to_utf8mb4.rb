class ChangeToUtf8mb4 < ActiveRecord::Migration[5.0]
  def self.up
    %w(definition_characters definitions syllables zi).each do |table|
      execute "alter table #{table} CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    end
  end
end
