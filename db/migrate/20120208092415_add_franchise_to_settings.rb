class AddFranchiseToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings,:franchise,:text unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :settings,:franchise
  end
end

