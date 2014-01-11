class AddColumnMailTypeToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :mail_check, :boolean, :default => 0
  end

  def self.down
    remove_column :comments, :mail_check
  end
end
