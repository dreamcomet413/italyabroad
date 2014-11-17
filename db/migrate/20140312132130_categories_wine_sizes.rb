class CategoriesWineSizes < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :categories_wine_sizes
      create_table :categories_wine_sizes, :id => false do |t|
        t.integer :category_id
        t.integer :wine_size_id
      end
    end
  end

  def self.down
    drop_table :categories_wine_sizes
  end
end
