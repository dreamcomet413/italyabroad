class RemoveGrapeColorsFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :grape_color_1
    remove_column :products, :grape_color_2
    remove_column :products, :grape_color_3
    remove_column :products, :grape_color_4
    remove_column :products, :grape_color_5
    remove_column :products, :grape_color_6
  end

  def self.down
    add_column :products, :grape_color_6, :string
    add_column :products, :grape_color_5, :string
    add_column :products, :grape_color_4, :string
    add_column :products, :grape_color_3, :string
    add_column :products, :grape_color_2, :string
    add_column :products, :grape_color_1, :string
  end
end
