class RemovecolumsfromcontactMessage < ActiveRecord::Migration
  def self.up
    remove_column :contact_messages, :phone, :email, :footer
  end

  def self.down
  end
end
