class AddMoodToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :mood, :string
  end

  def self.down
    remove_column :products, :mood
  end
end
