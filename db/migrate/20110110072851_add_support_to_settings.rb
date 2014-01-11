class AddSupportToSettings < ActiveRecord::Migration
  def self.up
      add_column :settings,:support,:string,:default=>'admin'
  end

  def self.down
    remove_column :settings,:support
  end
end

