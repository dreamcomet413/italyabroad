class AddAdminPaymentMethod < ActiveRecord::Migration
  def self.up
  	payment_method = PaymentMethod.new 
  	payment_method.name = 'Admin'
  	payment_method.vendor = 'Admin'
  	payment_method.save()
  end

  def self.down
  end
end
