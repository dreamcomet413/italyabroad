class Faq < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :question


end

