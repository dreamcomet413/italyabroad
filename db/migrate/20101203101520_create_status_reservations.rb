class CreateStatusReservations < ActiveRecord::Migration
  def self.up
    create_table :status_reservations do |t|
      t.string :name
    end
  end

  def self.down
    remove_table :status_reservations
  end
end

