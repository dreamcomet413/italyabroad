class AddFranchiseToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings,:franchise,:text
  end

  def self.down
    remove_column :settings,:franchise
  end
end

