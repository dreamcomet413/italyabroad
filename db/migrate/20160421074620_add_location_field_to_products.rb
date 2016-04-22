class AddLocationFieldToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :location, :string
  end

  def self.down
    remove_column :products, :location
  end
end
