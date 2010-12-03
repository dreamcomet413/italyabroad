class NewsLetterType < ActiveRecord::Base
  has_many :news_letters
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
