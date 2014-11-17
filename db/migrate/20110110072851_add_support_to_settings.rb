class AddSupportToSettings < ActiveRecord::Migration
  def self.up
      add_column :settings,:support,:string,:default=>'admin' unless column_exists?(:settings, :support)
  end

  def self.down
    remove_column :settings,:support
  end
end

