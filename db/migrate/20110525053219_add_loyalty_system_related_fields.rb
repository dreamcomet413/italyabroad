class AddLoyaltySystemRelatedFields < ActiveRecord::Migration
  def self.up
    add_column :settings,:points_per_pound,:float,:default=>0.00
    add_column :settings,:points_to_pound,:float,:default=>0.00
    add_column :orders,:points_used,:float,:default=>0.00
  end

  def self.down
    remove_column :settings,:points_per_pound
    remove_column :settings,:points_to_pound
    remove_column :orders,:points_used
  end
end

