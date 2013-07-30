class CreateProductSizes < ActiveRecord::Migration
  def self.up
    create_table :product_sizes do |t|
      t.string :size
      t.decimal :price
      t.integer :product_id
      t.default :boolean   
      t.timestamps
    end
  end

  def self.down
    drop_table :product_sizes
  end
end
