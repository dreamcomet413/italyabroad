class CreateAvailableChatUsers < ActiveRecord::Migration
  def self.up
    create_table :available_chat_users do |t|
      t.string :user_name
      t.timestamps
    end
  end

  def self.down
    drop_table :available_chat_users
  end
end
