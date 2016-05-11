class AddRecordsToSmallBoxSettings < ActiveRecord::Migration
  def self.up
  	SmallBoxSetting.create(box_title: 'grape_guides')
	SmallBoxSetting.create(box_title: 'moods')
	SmallBoxSetting.create(box_title: 'cercavino')
	SmallBoxSetting.create(box_title: 'hampers')
	SmallBoxSetting.create(box_title: 'upcoming_events')
	SmallBoxSetting.create(box_title: 'wine_club')
	SmallBoxSetting.create(box_title: 'our_community')
	SmallBoxSetting.create(box_title: 'andra_blog')
	SmallBoxSetting.create(box_title: 'share_italian_recipes')
	SmallBoxSetting.create(box_title: 'sign_up_as_chef')
  end

  def self.down
  	SmallBoxSetting.destroy_all
  end
end
