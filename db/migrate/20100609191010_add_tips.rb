class AddTips < ActiveRecord::Migration
  def self.up
    add_column :settings, :promotion, :string
  end

  def self.down
    remove_column :settings, :promotion
  end
end
