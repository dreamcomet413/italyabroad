class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts, :order => 'created_at DESC'
  has_many :posts_tags

  validates_uniqueness_of :name
  
  class << self
    def find_or_create_by_names(names = "")
      names.split(",").inject([]) { |ids, name|  ids << find_or_create_by_name(name.gsub(/^ /, "")).id }
    end
  end
end
