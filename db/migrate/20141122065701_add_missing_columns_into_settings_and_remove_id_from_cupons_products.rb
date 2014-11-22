class AddMissingColumnsIntoSettingsAndRemoveIdFromCuponsProducts < ActiveRecord::Migration
  def self.up
    remove_column :cupons_products, :id if column_exists?(:cupons_products, :id)
    add_column :settings, :home_page_meta_description, :string unless column_exists?(:settings, :home_page_meta_description)
    add_column :settings, :home_page_meta_key, :string unless column_exists?(:settings, :home_page_meta_key)
    add_column :settings, :chat_available, :boolean unless column_exists?(:settings, :chat_available)
  end

  def self.down
    remove_column :settings, :chat_available if column_exists?(:settings, :chat_available)
    remove_column :settings, :home_page_meta_key if column_exists?(:settings, :home_page_meta_key)
    remove_column :settings, :home_page_meta_description if column_exists?(:settings, :home_page_meta_description)
    add_column :cupons_products, :id, :integer unless column_exists?(:cupons_products, :id)
  end
end
