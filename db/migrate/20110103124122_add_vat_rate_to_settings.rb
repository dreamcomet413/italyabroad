class AddVatRateToSettings < ActiveRecord::Migration
   def self.up
    add_column :settings,:vat_rate,:decimal,:precision=>4,:scale=>2,:default=>0.00 unless column_exists?(:settings, :vat_rate)
  end

  def self.down
    remove_column :settings,:vat_rate
  end
end

