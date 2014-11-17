class AddMetaKeysAndDescriptionOfHomepageToSettings < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :settings,:home_page_meta_description,:string
      add_column :settings,:home_page_meta_key,:string
    #end
  end

  def self.down
    remove_column :settings,:home_page_meta_description
    remove_column :settings,:home_page_meta_key
  end
end

