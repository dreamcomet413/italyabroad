class AddFieldChatAvailableToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings,:chat_available,:boolean,:default=>false #unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :settings,:chat_available
  end
end

