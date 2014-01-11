class CreateProductsGrapes < ActiveRecord::Migration
  def self.up
    create_table :products_grapes, :force => true do |t|
      t.integer :product_id
      t.integer :grape_id
      t.timestamps
    end
  end

  def self.down
    drop_table :products_grapes
  end
end
