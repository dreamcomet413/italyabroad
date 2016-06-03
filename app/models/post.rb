class Post < ActiveRecord::Base
  validates_presence_of :name, :message => "of post can't be blank"
  validates_presence_of :description

  belongs_to :image_1, :class_name => "Image", :foreign_key => "image_1_id"
  belongs_to :image_2, :class_name => "Image", :foreign_key => "image_2_id"
  belongs_to :image_3, :class_name => "Image", :foreign_key => "image_3_id"

  belongs_to :resource_1, :class_name => "Resource", :foreign_key => "resource_1_id"
  belongs_to :resource_2, :class_name => "Resource", :foreign_key => "resource_2_id"
  belongs_to :resource_3, :class_name => "Resource", :foreign_key => "resource_3_id"

  has_many :comments do
    def latest
      self.all(:order => "created_at DESC")
    end
  end

  belongs_to :blog_type
  has_many :posts_tags
  has_many :tags, :through => :posts_tags

  friendly_identifier :name,:keep_updated => true

  scope :most_read, :order => "view_count DESC", :limit => 5

  def tag_names
    self.tags.collect(&:name).join(", ")
  end

  def count_view
    self.view_count += 1
    self.save(:validate=> false)
  end

  def description_cleared
    self.description.gsub("\n","<br />")
  end

  def description_short_cleared
    self.description_short.gsub("\n","<br />")
  end

  def page_title_formatted
    page_title.blank? ? name : page_title
  end

  def meta_description_formatted
    meta_description.blank? ? description[0..500] : meta_description
  end

  def meta_keys_formatted
    if meta_keys.blank?
      keys = []
      i = 0
      for key in description.downcase.split
        i += 1
        keys << key.to_s.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/-+$/, '').gsub(/^-+$/, '') unless keys.include?(key) || i > 21 || key.length < 4
      end
      return keys.join(", ")
    else
      return meta_keys
    end
  end

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end

  def self.archives
    blogs = find_by_sql(["SELECT COUNT(*) as count, EXTRACT(YEAR FROM created_at) as year, EXTRACT(MONTH FROM created_at) as month FROM posts WHERE created_at < ? GROUP BY year, month ORDER BY year desc, month desc", Time.now])
    blogs.collect(&:year).uniq.inject([]) do |results, year|
      archs = {}
      # months = {1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 9 => 0, 10 => 0, 11 => 0, 12 => 0}
      months = {}
      blogs.each do |blog|
        if blog.year == year
          month = blog.month.to_i
          count = blog.count.to_i
          months = months.merge({ month => count })
        end
      end
      archs[:year] = year.to_i
      archs[:months] = months.sort.reverse
      results << archs
    end
  end
end

