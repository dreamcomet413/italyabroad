class AddLoyaltySystemRelatedFields < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :settings,:points_per_pound,:float,:default=>0.00,:null=>false unless column_exists?(:settings, :points_per_pound)
      add_column :settings,:points_to_pound,:float,:default=>0.00,:null=>false unless column_exists?(:settings, :points_to_pound)
      add_column :orders,:points_used,:float,:default=>0.00,:null=>false unless column_exists?(:orders, :points_used)
    #end
  end

  def self.down
    remove_column :settings,:points_per_pound
    remove_column :settings,:points_to_pound
    remove_column :orders,:points_used
  end
end

