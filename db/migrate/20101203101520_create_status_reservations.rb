class CreateStatusReservations < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :status_reservations
      create_table :status_reservations do |t|
        t.string :name
      end
    end
  end

  def self.down
    remove_table :status_reservations if ActiveRecord::Base.connection.table_exists? :status_reservations
  end
end

