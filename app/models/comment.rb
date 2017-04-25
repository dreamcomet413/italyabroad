class Comment < ActiveRecord::Base
  apply_simple_captcha
  belongs_to :post
  belongs_to :user
  has_many :replies ,class_name: 'Comment', foreign_key: 'reply_id'
  belongs_to :comment , foreign_key: 'reply_id'
  validates_presence_of :name, :description
  after_save :approve 
  scope :latest, :conditions=>'public=true',:order => "created_at DESC", :limit => 2
  def approve
    if self.public_changed?
      if self.valid? and self.public == true  and !self.post.blank?
        self.post.comments.where(mail_check: true, public: true ).each do |comment|
          logger.info("-----------------------------------------------------------------------")
          logger.info(comment.id)
           logger.info(comment.user.blank?)
           if !comment.user.blank? and !self.user.blank?
             Notifier.comment(self, comment.user).deliver
           end
        end
      end
    end
  end
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end

