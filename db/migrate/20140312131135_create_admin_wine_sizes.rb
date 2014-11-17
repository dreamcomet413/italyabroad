class CreateAdminWineSizes < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :wine_sizes
      create_table :wine_sizes do |t|
        t.string :title
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :wine_sizes
  end
end
