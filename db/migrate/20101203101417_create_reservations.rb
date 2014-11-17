class CreateReservations < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :reservations
      create_table :reservations do |t|
        t.integer :restaurant_id
        t.references :user
        t.integer :status_reservation_id
        t.timestamps
        t.datetime :date
      end
    end
  end

  def self.down
    remove_column :reservations if ActiveRecord::Base.connection.table_exists? :reservations
  end
end

