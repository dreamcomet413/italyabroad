class AddFieldsToCupons < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == "production"
      add_column :cupons,:expiry_date,:date
      add_column :cupons,:created_by_admin,:boolean,:default=>false
      add_column :cupons,:no_of_times,:integer,:default=>1
      add_column :cupons,:no_of_times_used,:integer,:default=>0
    end
  end

  def self.down
    remove_column :cupons,:expiry_date
    remove_column :cupons,:created_by_admin
    remove_column :cupons,:no_of_times
    remove_column :cupons,:no_of_times_used
  end
end

