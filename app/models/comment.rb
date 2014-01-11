class Comment < ActiveRecord::Base
  apply_simple_captcha

  belongs_to :post
  belongs_to :user

  validates_presence_of :name, :description

  scope :latest, :conditions=>'public=true',:order => "created_at DESC", :limit => 2

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
