class CreateWineLists < ActiveRecord::Migration
  def self.up
    create_table :wine_lists do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :quantity
      t.timestamps
    end
  end

  def self.down
    drop_table :wine_lists
  end
end
