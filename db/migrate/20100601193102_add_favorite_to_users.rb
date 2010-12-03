class AddFavoriteToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :holidays, :string
    add_column :users, :songs, :string
    add_column :users, :films, :string
    add_column :users, :newspapers, :string
  end

  def self.down
    remove_column :users, :newspapers
    remove_column :users, :films
    remove_column :users, :songs
    remove_column :users, :holidays
  end
end
