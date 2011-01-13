class ChangeVatColumnTypeInSettings < ActiveRecord::Migration
  def self.up
    change_column :settings, :vat_rate,:string,:defualt=>0
  end

  def self.down
    change_column :settings, :vat_rate,:decimal,:precision=>4,:scale=>2,:default=>0.00
  end
end

