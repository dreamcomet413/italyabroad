class CreateOccasions < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :occasions
      create_table :occasions do |t|
        t.string :name
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :occasions
  end
end

