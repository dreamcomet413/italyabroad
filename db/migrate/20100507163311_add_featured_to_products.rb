class AddFeaturedToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :products, :column_name
    remove_column :products, :featured
  end
end
