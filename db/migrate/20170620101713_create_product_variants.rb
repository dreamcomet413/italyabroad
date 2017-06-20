class CreateProductVariants < ActiveRecord::Migration
  def change
  	 create_table :product_variants do |t|
      t.integer "product_id"
      t.integer "variant_id"
      t.timestamps
    end
  end
end
