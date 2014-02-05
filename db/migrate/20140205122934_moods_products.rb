class MoodsProducts < ActiveRecord::Migration
  def self.up
    create_table :moods_products, :id => false do |t|
      t.integer :mood_id
      t.integer :product_id
    end
  end

  def self.down
    drop_table :moods_products
  end
end
