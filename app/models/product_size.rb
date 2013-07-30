class ProductSize < ActiveRecord::Base    
    belongs_to :product
    validates_presence_of :size 
    validates_presence_of :price   
    validates_presence_of :product_id  
end
