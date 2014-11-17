class AddProducerPageQuoteToProducers < ActiveRecord::Migration
  def self.up
    add_column :settings,:producer_page_quote,:string unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :settings,:producer_page_quote
  end
end

