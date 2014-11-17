class AddLoyaltySystemRelatedFields < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :settings,:points_per_pound,:float,:default=>0.00,:null=>false
      add_column :settings,:points_to_pound,:float,:default=>0.00,:null=>false
      add_column :orders,:points_used,:float,:default=>0.00,:null=>false
    #end
  end

  def self.down
    remove_column :settings,:points_per_pound
    remove_column :settings,:points_to_pound
    remove_column :orders,:points_used
  end
end

