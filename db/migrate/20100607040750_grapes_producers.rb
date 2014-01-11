class GrapesProducers < ActiveRecord::Migration
  def self.up
    create_table :grapes_producers, :id => false, :force => true do |t|
      t.integer :grape_id
      t.integer :producer_id
    end
  end

  def self.down
    drop_table :grapes_producers
  end
end
