class AddFieldsToSmallBoxSettings < ActiveRecord::Migration
  def self.up
    add_column :small_box_settings, :content_type, :string
    add_column :small_box_settings, :description, :text
    SmallBoxSetting.all.each do |sb|
		if sb.box_title == 'wine_club_home'
			sb.content_type = 'text'
		else
			sb.content_type = 'image'
		end
    	sb.save
    end

  end

  def self.down
    remove_column :small_box_settings, :description
    remove_column :small_box_settings, :content_type
  end
end
