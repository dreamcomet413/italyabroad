class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.integer :score
      t.timestamps
    end
  end

  def self.down
    remove_table :rates
  end
end

