class AddColumnCuponTypeToCupons < ActiveRecord::Migration
  def self.up
    add_column :cupons, :cupon_type, :string, :default => "price"
  end

  def self.down
    remove_column :cupons, :cupon_type
  end
end
