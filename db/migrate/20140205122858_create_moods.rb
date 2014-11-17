class CreateMoods < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :moods
      create_table :moods do |t|
        t.string :name

        t.timestamps
      end
    end
  end

  def self.down
    drop_table :moods
  end
end
