class CreateSmallBoxSettings < ActiveRecord::Migration
  def self.up
    create_table :small_box_settings do |t|
    	t.string :box_title
      t.timestamps
    end
    add_column :small_box_settings , :image_id , :integer
  end

  def self.down
    drop_table :small_box_settings
  end
end
