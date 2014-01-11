class CreateProducers < ActiveRecord::Migration
  def self.up
    create_table :producers, :force => true do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    
    create_table :producers_products, :force => true do |t|
      t.integer :producer_id
      t.integer :product_id
    end
  end

  def self.down
    drop_table :producers
  end
end
