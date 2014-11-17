class CreateRates < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :rates
      create_table :rates do |t|
        t.integer :score
        t.timestamps
      end
    end
  end

  def self.down
    remove_table :rates if ActiveRecord::Base.connection.table_exists? :rates
  end
end

