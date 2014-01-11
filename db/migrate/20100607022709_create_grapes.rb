class CreateGrapes < ActiveRecord::Migration
  def self.up
    create_table :grapes, :force => true do |t|
      t.string :name
      t.text :description
      t.integer :image_id
      t.timestamps
    end
  end

  def self.down
    drop_table :grapes
  end
end
