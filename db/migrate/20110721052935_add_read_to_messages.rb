class AddReadToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages,:read_or_not,:boolean,:default=>false unless RAILS_ENV == "production"
  end

  def self.down
    remove_column :messages,:read_or_not
  end
end

