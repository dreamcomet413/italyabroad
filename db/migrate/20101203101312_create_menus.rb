class CreateMenus < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == "production"
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
    remove_table :menus unless RAILS_ENV == "production"
  end
end

