class AddRecordDataToSmallBoxSetting < ActiveRecord::Migration
  def self.up
  	SmallBoxSetting.create(box_title: 'blog_home')
  	SmallBoxSetting.create(box_title: 'wine_club_home')
  end

  def self.down
  	small_box_setting = SmallBoxSetting.where(box_title: 'blog_home')
  	small_box_setting.destroy
  	small_box_setting = SmallBoxSetting.where(box_title: 'wine_club_home')
  	small_box_setting.destroy
  end
end
