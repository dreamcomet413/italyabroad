class Cart
  attr_reader :items
  attr_accessor :show_errors, :show_warnings, :cupon, :delivery, :gift, :quantity

  def initialize
    @items = []
    @delivery = Delivery.find(:first)
    @gift = GiftItem.new
  end

  def create(product, quantity = 1)
    current_item = @items.find { |t| t.product == product }
    if quantity.to_i < 1
      @show_warnings = "Quantity of #{product.name} must be greater than one."
      return false
    end

    current_item ||= CartItem.new(product, quantity)

    if quantity.to_i > current_item.product.quantity
      @show_warnings = "Sorry, only #{current_item.product.quantity} left. Will inform you when more will become available."
      return false
    else
      if @items.include?(current_item)
        current_item.quantity = quantity
      else
        @items << current_item
      end
      return true
    end
  end

  def destroy(product_id)
    current_item = @items.find { |t| t.product.id == product_id.to_i }
    if current_item
      @items.delete current_item
    end
  end

  def product_ids
    items.inject([]) {|ids, t| ids << t.product.id}
  end

  def update(items, cupon_code, delivery_id)
    @show_warnings = ""
    for item in items
      current_item = @items.find { |t| t.product.id == item[:id].to_i }
      if current_item
        if item[:quantity].to_i < 1
          @show_warnings = "Quantity of #{current_item.product.name} must be greater than one."
        elsif item[:quantity].to_i > current_item.product.quantity
          @show_warnings = "Sorry, we only have #{current_item.product.quantity} #{current_item.product.name} left"
          current_item.quantity = current_item.product.quantity
        else
          current_item.quantity = item[:quantity]
        end
      end
    end

    @delivery = Delivery.find_by_id(delivery_id)
    @cupon = Cupon.find_by_code(cupon_code)

    return valid?
  end

  def order_cupon_amount
    @cupon = Cupon.find(@cupon.id)
    if @cupon && (@cupon.min_order.nil? || @cupon.min_order > 0)
      return @cupon.min_order
    else
      return 1
    end
  end

  def valid?
    @show_errors = ""

    limit = Setting.order_amount
    limit = order_cupon_amount if @cupon

    if @delivery.nil?
      @show_errors = "Please select a delivery"
    end

    if sub_total < limit
      if @cupon
        @show_errors = "Sorry, but to be able to use the voucher there is a minimum order of £#{limit}"
      else
        @show_errors = "Sorry, but there is a miminum order of £#{limit}"
      end
    end

    if @cupon
      unless @cupon.products.nil? or @cupon.products.empty?
        coupon_product_ids = @cupon.products.map {|i| i.id }
        coupon_products_subtotal = 0
        items.each {|item| coupon_products_subtotal += item.total if coupon_product_ids.include? item.product.id }
        @show_errors = "Sorry, this voucher only gives discount on certain products with a minimum order of £#{limit}" if coupon_products_subtotal < limit
      end
    end

    return @show_errors.blank? ? true : false
  end

  def sub_total
    total = 0
    disc = 0
    @items.each { |t| total += t.total }
    total -= buy_together_discount
    if @cupon && @cupon.active
      unless @cupon.products.nil? or @cupon.products.empty?
        coupon_product_ids = @cupon.products.map {|i| i.id }
        coupon_products_subtotal = 0
        if @cupon.cupon_type != "percentage"
          items.each {|item| coupon_products_subtotal += item.total if coupon_product_ids.include? item.product.id }
          total -= @cupon.price if coupon_products_subtotal > @cupon.min_order
        else
          items.each {|item|
            if coupon_product_ids.include? item.product.id
              coupon_products_subtotal += item.total
              disc += (item.total*(@cupon.price))/100
            end
          }
          total -= disc if coupon_products_subtotal > @cupon.min_order
        end
      else
        if @cupon.cupon_type != "percentage"
          total -= @cupon.price
        else
          total -= (total*(@cupon.price))/100
        end
      end
    end
    return total
  end

  def total
    total  = sub_total
    total += total < Setting.order_delivery_amount && @delivery ? @delivery.price : 0
    total += @gift.price if @gift
    return total
  end

  def buy_together_discount
    all_coupons = []
    coupons_to_apply = []
    discount = 0
    discount_multiple = []
    @items.each do |item|
      if item.product.cupons
        item.product.cupons.each do |coupon|
          if all_coupons.include? coupon.cupon_id
            coupons_to_apply << coupon.cupon_id
          else
            all_coupons << coupon.cupon_id
          end
        end
        discount_multiple << item.quantity
      end
    end
    if !coupons_to_apply.empty?
      discount = discount_multiple.sort.first * Cupon.find(coupons_to_apply.uniq.first).price
    end
    discount
  end
end