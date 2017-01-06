class AddSpecielOfferToProducts < ActiveRecord::Migration
  def change
    add_column :products, :on_offer, :boolean, :default => false
  end
end
