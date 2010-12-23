class AddReorderQuanityToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings,:reorder_quantity,:integer,:default=>10
  end

  def self.down
    remove_column :settings,:reorder_quantity
  end
end

