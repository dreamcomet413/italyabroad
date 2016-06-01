class AddSommelierAndWineMoodImagesToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :sommelier_image_id, :integer
    add_column :settings, :wine_mood_image_id, :integer
  end

  def self.down
    remove_column :settings, :wine_mood_image_id
    remove_column :settings, :sommelier_image_id
  end
end
