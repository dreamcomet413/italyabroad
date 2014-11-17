class AddChefDetailsToUser < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :users, :chef_bio, :string
      add_column :users, :establishment_link, :string
    #end
  end

  def self.down
    remove_column :users, :establishment_link
    remove_column :users, :chef_bio
  end
end
