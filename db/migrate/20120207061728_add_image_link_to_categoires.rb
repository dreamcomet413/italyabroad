class AddImageLinkToCategoires < ActiveRecord::Migration
  def self.up
    add_column :categories,:image_link,:string #unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :categories,:image_link
  end
end

