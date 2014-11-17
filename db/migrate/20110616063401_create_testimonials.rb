class CreateTestimonials < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :testimonials
      create_table :testimonials do |t|
        t.string :title
        t.string :description
        t.string :page_to_display
        t.integer :sequence,:null=>true
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :testimonials
  end
end

