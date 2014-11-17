class CreateMenus < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? :menus
      create_table :menus do |t|
        t.integer :parent_id
        t.integer :lft
        t.integer :rgt
        t.string :name
        t.string :controller
        t.string :action
      end
    end
  end

  def self.down
    remove_table :menus if ActiveRecord::Base.connection.table_exists? :menus
  end
end

