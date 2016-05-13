class AddFieldToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :is_landscape, :boolean
  end

  def self.down
    remove_column :products, :is_landscape
  end
end
