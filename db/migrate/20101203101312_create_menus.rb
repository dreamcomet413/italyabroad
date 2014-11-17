class CreateMenus < ActiveRecord::Migration
  def self.up
    #create_table :menus do |t|
    #  t.integer :parent_id
    #  t.integer :lft
    #  t.integer :rgt
    #  t.string :name
    #  t.string :controller
    #  t.string :action
    #end
  end

  def self.down
    remove_table :menus
  end
end

