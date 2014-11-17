class CreateDesiredExpenditures < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :desired_expenditures
      create_table :desired_expenditures do |t|
        t.string :title
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :desired_expenditures
  end
end
