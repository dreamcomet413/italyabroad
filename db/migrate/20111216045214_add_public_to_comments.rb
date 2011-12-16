class AddPublicToComments < ActiveRecord::Migration
  def self.up
      add_column :comments,:public,:boolean,:default=>false,:null=>false
  end

  def self.down
    remove_column :comments,:public
  end
end

