class AddMetaKeysAndDescriptionOfHomepageToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings,:home_page_meta_description,:string
    add_column :settings,:home_page_meta_key,:string
  end

  def self.down
    remove_column :settings,:home_page_meta_description
    remove_column :settings,:home_page_meta_key
  end
end

