class AddProducerTextToProducers < ActiveRecord::Migration
  def self.up
    add_column :producers, :producer_text, :text
  end

  def self.down
    remove_column :producers, :producer_text
  end
end
