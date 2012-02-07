class AddImageLinkToCategoires < ActiveRecord::Migration
  def self.up
    add_column :categories,:image_link,:string
  end

  def self.down
    remove_column :categories,:image_link
  end
end

