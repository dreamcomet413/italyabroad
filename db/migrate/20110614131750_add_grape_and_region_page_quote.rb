class AddGrapeAndRegionPageQuote < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :settings,:grape_page_quote,:string unless column_exists?(:orders, :grape_page_quote)
      add_column :settings,:region_page_quote,:string unless column_exists?(:orders, :region_page_quote)
    #end
  end

  def self.down
    remove_column :settings,:grape_page_quote
    remove_column :settings,:region_page_quote
  end
end

