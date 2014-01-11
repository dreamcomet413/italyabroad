class AddPhotoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :photo_id, :integer
    add_column :users, :photo_default, :string
  end

  def self.down
    remove_column :users, :photo_default
    remove_column :users, :photo_id
  end
end
