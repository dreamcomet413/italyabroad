class Review < ActiveRecord::Base
  belongs_to :reviewer, :polymorphic => true
  belongs_to :user

  validates_presence_of     :name, :description
   #before_create :send_notification
  after_save :copy_reviewer_variants
  def copy_reviewer_variants
    if reviewer_type == "Product"
        new_review_attribs = self.attributes.except("id",'reviewer_id','created_at','updated_at')
        self.reviewer.variants.each do |product|
          new_review_attribs['reviewer_id'] = product.id
          if Review.where(new_review_attribs).blank?
             reviewer = Review.new(new_review_attribs)
             reviewer.save
          end
        
        end
    
    end

  end

  def send_notification
    Notifier.new_review(self).deliver
  end

  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end

