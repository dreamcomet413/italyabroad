class AddGrapeAndRegionPageQuote < ActiveRecord::Migration
  def self.up
    add_column :settings,:grape_page_quote,:string
    add_column :settings,:region_page_quote,:string
  end

  def self.down
    remove_column :settings,:grape_page_quote
    remove_column :settings,:region_page_quote
  end
end

