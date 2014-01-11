class NewsLettersProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :news_letter
end