class AddQuoteToProducersRegionsGrapes < ActiveRecord::Migration
  def self.up
    add_column :producers,:producer_quote,:string
    add_column :grapes,:grape_quote,:string
    add_column :regions,:region_quote,:string
    remove_column :settings,:producer_page_quote
    remove_column :settings,:grape_page_quote
    remove_column :settings,:region_page_quote
  end

  def self.down
    add_column :settings,:producer_page_quote,:string
    add_column :settings,:grape_page_quote,:string
    add_column :settings,:region_page_quote,:string
    remove_column :producers,:producer_quote
    remove_column :grapes,:grape_quote
    remove_column :regions,:region_quote
  end
end

