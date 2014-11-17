class AddGrapeAndRegionPageQuote < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :settings,:grape_page_quote,:string
      add_column :settings,:region_page_quote,:string
    #end
  end

  def self.down
    remove_column :settings,:grape_page_quote
    remove_column :settings,:region_page_quote
  end
end

