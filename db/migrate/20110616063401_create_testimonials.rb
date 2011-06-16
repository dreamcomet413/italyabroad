class CreateTestimonials < ActiveRecord::Migration
  def self.up
    create_table :testimonials do |t|
      t.string :title
      t.string :description
      t.string :page_to_display
      t.integer :sequence
      t.timestamps
    end
  end

  def self.down
    drop_table :testimonials
  end
end

