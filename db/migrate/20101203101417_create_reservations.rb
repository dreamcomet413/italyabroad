class CreateReservations < ActiveRecord::Migration
  def self.up
     create_table :reservations do |t|
       t.integer :restaurant_id
       t.references :user
       t.integer :status_reservation_id
       t.timestamps
       t.datetime :date
     end
  end

  def self.down
    remove_column :reservations
  end
end

