class CreateAvailableChatUsers < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :available_chat_users
      create_table :available_chat_users do |t|
        t.string :user_name
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :available_chat_users
  end
end
