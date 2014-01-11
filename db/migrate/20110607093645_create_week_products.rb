class CreateWeekProducts < ActiveRecord::Migration
  def self.up
    create_table :week_products do |t|
      t.integer :week_product_id
      t.timestamps
    end
  end

  def self.down
    drop_table :week_products
  end
end

