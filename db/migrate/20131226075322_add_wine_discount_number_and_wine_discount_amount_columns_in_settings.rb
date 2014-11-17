class AddWineDiscountNumberAndWineDiscountAmountColumnsInSettings < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == "production"
      add_column :settings, :wine_discount_number, :integer, :default => 0
      add_column :settings, :wine_discount_amount, :float, :default => 0.0
    end
  end

  def self.down
    remove_column :settings, :wine_discount_number
    remove_column :settings, :wine_discount_amount
  end
end
