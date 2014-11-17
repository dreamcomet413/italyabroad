class AddOccasionIdToProducts < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :products,:occasion_id,:integer,:default=>0 unless column_exists?(:products, :occasion_id)
    #end
  end

  def self.down
    remove_column :products,:occasion_id
  end
end

