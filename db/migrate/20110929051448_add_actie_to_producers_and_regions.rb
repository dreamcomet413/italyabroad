class AddActieToProducersAndRegions < ActiveRecord::Migration
  def self.up
    #unless RAILS_ENV == "production"
      add_column :producers,:active,:boolean,:default=>true
      add_column :regions,:active,:boolean,:default=>true
    #end
  end

  def self.down
     remove_column :producers,:active
     remove_column :regions,:active
  end
end

