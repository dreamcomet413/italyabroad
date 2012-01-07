class AddCreatedAtToCupons < ActiveRecord::Migration
  def self.up
    add_column :cupons,:created_at,:date,:default=>Date.today
  end

  def self.down
    remove_column :cupons,:created_at
  end
end

