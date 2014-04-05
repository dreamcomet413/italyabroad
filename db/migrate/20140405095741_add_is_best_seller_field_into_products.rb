class AddIsBestSellerFieldIntoProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :is_best_seller, :boolean
  end

  def self.down
    remove_column :products, :is_best_seller
  end
end
