class AddPublishReviews < ActiveRecord::Migration
  def self.up
    add_column :reviews,:publish,:boolean,:default=>false
  end

  def self.down
    remove_column :reviews,:publish
  end
end

