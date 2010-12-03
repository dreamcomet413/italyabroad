class ForumPost < ActiveRecord::Base
  def self.per_page() 25 end

  belongs_to :forum
  belongs_to :user
  belongs_to :topic

  format_attribute :body
  before_create { |r| r.forum_id = r.topic.forum_id }
  after_create  :update_cached_fields
  after_destroy :update_cached_fields

  validates_presence_of :user_id, :body, :topic
  attr_accessible :body	

  def deliver_notification
    Notifier.deliver_topic_replied_notification(self) if self.user_id != self.topic.user_id
  end

  def editable_by?(user)
    user && (user.id == user_id || user.admin? || user.moderator_of?(forum_id))
  end
  
  def to_xml(options = {})
    options[:except] ||= []
    options[:except] << :topic_title << :forum_name
    super
  end

  def forum_name
    self.forum.name
  end

  def topic_title
    self.topic.title
  end
  
  protected
    # using count isn't ideal but it gives us correct caches each time
    def update_cached_fields
      Forum.update_all ['posts_count = ?', ForumPost.count(:id, :conditions => {:forum_id => forum_id})], ['id = ?', forum_id]
      User.update_posts_count(user_id)
      topic.update_cached_post_fields(self)
    end
end
