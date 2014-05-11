class CreateContactMessages < ActiveRecord::Migration
  def self.up
    create_table :contact_messages do |t|
      t.string :header
      t.text :message
      t.string :phone
      t.string :email
      t.string :footer
      t.timestamps
    end
  end

  def self.down
    drop_table :contact_messages
  end
end
