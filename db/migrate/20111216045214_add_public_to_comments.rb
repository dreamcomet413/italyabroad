class AddPublicToComments < ActiveRecord::Migration
  def self.up
      add_column :comments,:public,:boolean,:default=>false,:null=>false unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :comments,:public
  end
end

