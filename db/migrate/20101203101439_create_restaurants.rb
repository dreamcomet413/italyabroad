class CreateRestaurants < ActiveRecord::Migration
  def self.up
    create_table :restaurants do |t|
     t.string :name
     t.string :lunch
     t.string :dinner
     t.string :weekend_lunch
     t.string :weekend_dinner
     t.string :reservation
     t.decimal :cost,:default=>'0.00'
     t.string :closed
     t.text :happy_hour
     t.text :regional_cuisine
     t.text :address
     t.text :description
     t.boolean :online_reservation
     t.string :page_title
     t.string :meta_keys
     t.text :meta_description
     t.integer :image_1_id
     t.integer :image_2_id
     t.integer :image_3_id
     t.integer :resource_1_id
     t.integer :resource_2_id
     t.integer :resource_3_id
     t.string :telephone
     t.string :fax
     t.string :mobile
     t.string :email
     t.string :website
     t.timestamps
     t.text :google_map_link
     t.boolean :raccomanded,:default=>0
     t.integer :rating
     t.string :city
     t.string :cap
     t.string :style
     t.boolean :active,:default=>0
    end
  end

  def self.down
    remove_table :restaturants
  end
end

