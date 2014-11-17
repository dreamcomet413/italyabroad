class MoodsProducts < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :moods_products
      create_table :moods_products, :id => false do |t|
        t.integer :mood_id
        t.integer :product_id
      end
    end
  end

  def self.down
    drop_table :moods_products
  end
end
