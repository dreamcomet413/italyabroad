
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

namespace :special_offers do
  desc "Remove Special Offers entry from Category table"
  task :remove => :environment do
    s = Category.find_by_name("Special Offers")
    s.delete
  end
end

namespace :product_price do
  desc "Move product price and quantity in Product price table"
  task :move => :environment do
    class Product < ActiveRecord::Base
      establish_connection "nov18"
      sql = "INSERT INTO product_prices (product_id,price,quantity) SELECT DISTINCT id,price,quantity FROM italyabroad_production_18Nov2014.products;"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
