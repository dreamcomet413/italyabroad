class Faq < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :question

   def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end

end

