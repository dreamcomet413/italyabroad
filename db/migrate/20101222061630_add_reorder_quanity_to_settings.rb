class AddReorderQuanityToSettings < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :settings,:reorder_quantity,:integer,:default=>10 unless column_exists?(:settings, :reorder_quantity)
    #end
  end

  def self.down
    remove_column :settings,:reorder_quantity
  end
end

