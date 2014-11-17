class CreateIncompletePurchases < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :incomplete_purchases
      create_table :incomplete_purchases do |t|
        t.string :email
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :incomplete_purchases
  end
end

