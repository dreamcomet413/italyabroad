class CreateProductsWineSizes < ActiveRecord::Migration
  def self.up
    create_table :products_wine_sizes, :id => false do |t|
      t.integer :product_id
      t.integer :wine_size_id
    end
  end

  def self.down
    drop_table :products_wine_sizes
  end
end
