class AddHeaderTextRecordToSmallBoxSettings < ActiveRecord::Migration
  def change
  	SmallBoxSetting.create(box_title: 'header_left_text' , content_type: 'text')
  	SmallBoxSetting.create(box_title: 'header_right_text' , content_type: 'text')
  end
  
end
