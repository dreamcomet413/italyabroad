class ChangeFromDecimalToFloatInProductPrices < ActiveRecord::Migration
  def self.up
    change_column :product_prices, :price, :float
  end

  def self.down
    change_column :product_prices, :price, :decimal
  end
end
