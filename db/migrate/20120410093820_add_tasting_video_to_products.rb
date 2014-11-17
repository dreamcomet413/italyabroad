class AddTastingVideoToProducts < ActiveRecord::Migration
  def self.up
    add_column :products,:tasting_video,:string unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :products,:tasting_video
  end
end

