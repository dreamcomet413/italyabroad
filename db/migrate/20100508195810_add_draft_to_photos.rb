class AddDraftToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :draft, :boolean, :default => true
  end

  def self.down
    remove_column :photos, :draft
  end
end
