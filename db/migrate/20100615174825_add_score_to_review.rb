class AddScoreToReview < ActiveRecord::Migration
  def self.up
    add_column :reviews, :score, :integer
  end

  def self.down
    remove_column :reviews, :score
  end
end
