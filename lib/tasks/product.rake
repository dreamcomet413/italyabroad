
namespace :product do
  desc "Move all product price and quantity in Product price table"
  task :price_quantity => :environment do
    Product.find_each do |product|
      product.product_prices.create(
        :price => product.try(:price),
        :quantity => product.try(:quantity),
        :product_id => product.id
      )
      puts "Product id = #{product.id}  data is successfully migrated."
    end
  end

  desc "Remove Price and Quantity columns form Product table"
  task :remove_column => :environment do
    ActiveRecord::Migration.remove_column :products, :price, :quantity
  end
end
