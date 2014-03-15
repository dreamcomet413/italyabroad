class CreateFoodOptions < ActiveRecord::Migration
  def self.up
    create_table :food_options do |t|
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :food_options
  end
end
