class Order < ActiveRecord::Base
  validates_presence_of :status_order_id
    
  belongs_to :user
  belongs_to :status_order
  belongs_to :gift_option
  belongs_to :payment_method
  
  has_many :order_items, :dependent => :destroy
  
  after_update do |order|
    Notifier.deliver_status_order(order) if order.status_order.name.downcase == "complete"
  end
  
  def customer
    if user
      return user.name + " " + user.surname
    else
      return "*Customer deleted*"
    end
  end
  
   def sub_total
    total = 0
    for order_item in order_items
      total += order_item.price * order_item.quantity
    end
    total -= buy_together_discount
    return total
  end
  
  def total
    total  = sub_total
    total += delivery_price if total < Setting.order_delivery_amount
    total -= cupon_price
    total += gift_option.price if gift_option
    return total
  end 

  def buy_together_discount
    all_coupons = []
    coupons_to_apply = []
    discount = 0
    discount_multiple = []
    order_items.each do |item|
      unless item.product.nil?
        item.product.cupons.each do |coupon|
          if all_coupons.include? coupon.cupon_id
            coupons_to_apply << coupon.cupon_id
          else
            all_coupons << coupon.cupon_id
          end
        end
      end
      discount_multiple << item.quantity
    end
    discount = discount_multiple.sort.first * Cupon.find(coupons_to_apply.uniq.first).price unless coupons_to_apply.empty?
    discount
  end
  
  def has_wines?
    order_items.each do |order_item| 
      if product = Product.find_by_name(order_item.name)
        return true if product.is_wine?
      end
    end
    return false
  end
  
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end

