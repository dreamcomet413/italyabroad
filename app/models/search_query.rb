class SearchQuery < ActiveRecord::Base
  validates_presence_of :query

  def self.popular_searches(limit=7)
    self.find(:all, :select => "COUNT(query) as popularity, query", :group => "query", :order => "popularity desc", :limit => limit).sort_by { rand() }
  end

  def self.popular_searches_box(limit=7)
    self.find(:all, :select => "COUNT(query) as popularity, query", :group => "query", :order => "popularity desc", :limit => limit)
  end

end

