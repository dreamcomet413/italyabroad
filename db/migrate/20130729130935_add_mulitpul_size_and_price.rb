class AddMulitpulSizeAndPrice < ActiveRecord::Migration
     def self.up
         add_column :products,:multiple,:boolean , :default => false   
         add_column :products,:defalult_product_size,:integer 
     end

     def self.down
        remove_column :products,:multiple
     end
end
