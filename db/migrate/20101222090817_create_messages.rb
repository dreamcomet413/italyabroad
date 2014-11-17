class CreateMessages < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :messages
      create_table :messages do |t|
        t.string :name
        t.references :user
        t.integer :send_by_id
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :messages
  end
end

