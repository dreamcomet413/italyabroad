class AddCouponSendToReviews < ActiveRecord::Migration
  def self.up
    add_column :reviews,:cupon_send,:boolean,:default=>false
  end

  def self.down
    remove_column :reviews,:cupon_send
  end
end

