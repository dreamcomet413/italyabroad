class CreateIncompletePurchases < ActiveRecord::Migration
  def self.up
    create_table :incomplete_purchases do |t|
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table :incomplete_purchases
  end
end

