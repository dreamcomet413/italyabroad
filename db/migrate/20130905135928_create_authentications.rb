class CreateAuthentications < ActiveRecord::Migration
  def self.up
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :auth_token
      t.string :auth_secret
      t.string :user_name

      t.timestamps
    end
  end

  def self.down
    drop_table :authentications
  end
end
