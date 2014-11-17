class AddMulitpulSizeAndPrice < ActiveRecord::Migration
     def self.up
       #unless RAILS_ENV == "production"
         add_column :products,:multiple,:boolean , :default => false   
         add_column :products,:defalult_product_size,:integer 
      #end
     end

     def self.down
        remove_column :products,:multiple
     end
end
