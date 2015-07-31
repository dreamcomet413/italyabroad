class AddSearchRelatedFieldsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :surprise_me, :boolean, :default => false
    add_column :products, :body_type, :string
    add_column :products, :with_food_type, :string
  end

  def self.down
    remove_column :products, :surprise_me
    remove_column :products, :body_type
    remove_column :products, :with_food_type
  end
end
