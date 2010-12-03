class CreateProductIncludeds < ActiveRecord::Migration
  def self.up
    create_table :product_includeds do |t|
      t.integer "product_id"
      t.integer "included_product_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :product_includeds
  end
end
