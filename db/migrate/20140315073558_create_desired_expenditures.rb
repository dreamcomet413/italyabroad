class CreateDesiredExpenditures < ActiveRecord::Migration
  def self.up
    create_table :desired_expenditures do |t|
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :desired_expenditures
  end
end
