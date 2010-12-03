class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :image_filename
      t.integer :image_width
      t.integer :image_height
      t.timestamps
    end
    rename_column :images, :name, :image_filename
    add_column :images, :image_width, :integer
    add_column :images, :image_height, :integer
  end

  def self.down
    remove_column :images, :image_height
    remove_column :images, :image_width
    rename_column :images, :image_filename, :name
    drop_table :photos
  end
end
