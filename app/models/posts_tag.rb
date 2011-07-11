class PostsTag <  ActiveRecord::Base
  belongs_to :post
  belongs_to :tag
  
  class << self
    def popular_tags
      find(:all, :select => "COUNT(tag_id) AS popularity, tag_id,post_id", :group => "tag_id", :order => "popularity DESC", :limit => 10).sort_by { rand() }
    end
  end
end

