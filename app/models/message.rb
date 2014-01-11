class Message < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end

