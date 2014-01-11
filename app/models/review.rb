class Review < ActiveRecord::Base
  belongs_to :reviewer, :polymorphic => true
  belongs_to :user

  validates_presence_of     :name, :description
   #before_create :send_notification

  def send_notification
    Notifier.deliver_new_review(self)
  end
end

