class AddChefDetailsToUser < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :users, :chef_bio, :string unless column_exists?(:users, :chef_bio)
      add_column :users, :establishment_link, :string unless column_exists?(:users, :establishment_link)
    #end
  end

  def self.down
    remove_column :users, :establishment_link
    remove_column :users, :chef_bio
  end
end
