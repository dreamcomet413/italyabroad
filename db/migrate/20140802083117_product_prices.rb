class ProductPrices < ActiveRecord::Migration
  def self.up
    create_table :product_prices do |t|
      t.decimal :price
      t.decimal :quantity
      t.integer :product_id
      t.timestamps
    end
  end

  def self.down
    drop_table :product_prices
  end
end
