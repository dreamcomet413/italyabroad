class CreateFoodOrDrinks < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :food_or_drinks
      create_table :food_or_drinks do |t|
        t.string :title
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :food_or_drinks
  end
end
