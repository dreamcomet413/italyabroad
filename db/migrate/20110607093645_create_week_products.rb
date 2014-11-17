class CreateWeekProducts < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :week_products
      create_table :week_products do |t|
        t.integer :week_product_id
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :week_products
  end
end

