class AddImageToMoods < ActiveRecord::Migration
  def self.up
    add_column :moods, :image, :string
  end

  def self.down
    remove_column :moods, :image
  end
end
