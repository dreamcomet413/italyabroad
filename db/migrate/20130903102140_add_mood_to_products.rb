class AddMoodToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :mood, :string  unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :products, :mood
  end
end
