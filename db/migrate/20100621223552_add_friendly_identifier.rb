class AddFriendlyIdentifier < ActiveRecord::Migration
  def self.up
    add_column :grapes, :friendly_identifier, :string
    add_column :regions, :friendly_identifier, :string
    add_column :producers, :friendly_identifier, :string
  end

  def self.down
    remove_column :producers, :friendly_identifier
    remove_column :regions, :friendly_identifier
    remove_column :grapes, :friendly_identifier
  end
end
