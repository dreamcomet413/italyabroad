class Comment < ActiveRecord::Base
  apply_simple_captcha
  belongs_to :post
  belongs_to :user
  has_many :replies ,class_name: 'Comment', foreign_key: 'reply_id'
  belongs_to :comment , foreign_key: 'reply_id'
  validates_presence_of :name, :description

  scope :latest, :conditions=>'public=true',:order => "created_at DESC", :limit => 2

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end

