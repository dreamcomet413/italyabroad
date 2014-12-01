class Cart
  attr_reader :items
  attr_accessor :show_errors, :show_warnings, :cupon, :delivery, :gift, :quantity

  def initialize
    @items = []
    @delivery = Delivery.find(:first)
    # @gift = GiftItem.new
  end

  def create(product, quantity = 1, discounted_price = 0.0)
    current_item = @items.find { |t| t.product == product }
    if quantity.to_i < 1
      @show_warnings = "Quantity of #{product.name} must be greater than one."
      return false
    end


    current_item ||= CartItem.new(product, quantity, discounted_price)
    current_item_quantity = current_item.product.product_prices.find_by_price(discounted_price).present? ?
        current_item.product.product_prices.find_by_price(discounted_price).quantity.to_i : current_item.product.product_prices.try(:first).try(:quantity).try(:to_i)
    if quantity.to_i > current_item_quantity
      #  @show_warnings = "Sorry, only #{current_item.product.quantity} left. Will inform you when more will become available."
      @show_warnings = "Sorry, none left, please drop us an email and we will inform you when more will become available"
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
    total_amount = 0
    for item in items
      current_item = @items.find { |t| t.product.id == item[:id].to_i }
      if current_item
        if item[:quantity].to_i < 1
          @show_warnings = "Quantity of #{current_item.product.name} must be greater than one."
        elsif item[:quantity].to_i > current_item.product.quantity.to_i
          @show_warnings = "Sorry, we only have #{current_item.product.quantity} #{current_item.product.name} left"
          current_item.quantity = current_item.product.quantity
        else
          current_item.quantity = item[:quantity]
        end
        total_amount += item[:quantity].to_i * item[:price].to_i

      end
    end


    @delivery = Delivery.find_by_id(delivery_id)

    #if delivery_charge == false and [4,7,10].include?(delivery_id)
    if total_amount > Setting.find(:first).order_delivery_amount and Delivery.find_by_id(delivery_id).bulk_order_price == 0
      @delivery.price = 0
    end



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
        @show_warnings = "Sorry, this voucher only gives discount on certain products with a minimum order of £#{limit}" if coupon_products_subtotal < limit
      end
    end

    return @show_errors.blank? ? true : false
  end

  def sub_total
    total = 0
    disc = 0
    @items.each { |t| total += t.total }

    total -= buy_together_discount

    cupon_is_active = false
    if (@cupon and @cupon.active and @cupon.created_by_admin and @cupon.expiry_date >= Date.today and @cupon.no_of_times > @cupon.no_of_times_used )
      cupon_is_active = true
    elsif (@cupon and @cupon.active and (@cupon.created_at + 30.days) >= Date.today)
      cupon_is_active = true
    end
    if @cupon and cupon_is_active == false
      @show_warnings = "Voucher expired, Please enter a valid one."
    end


    # if @cupon && @cupon.active  and (@cupon.created_at + 30.days) >= Date.today
    if cupon_is_active


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
    @setting = Setting.first
    @number_of_wines_in_cart = 0
    @items.each do  |t|
      @p = Product.find(t.product.id)

      if @p.categories.root.name == "Wine"
        if t.quantity >= 1 and @setting.wine_discount_number.to_i != 0 and @setting.wine_discount_amount.to_i != 0
          @number_of_wines_in_cart = @number_of_wines_in_cart + t.quantity.to_i
        end
      end
    end
    if @number_of_wines_in_cart >=  @setting.wine_discount_number.to_i
     total  -= ((total*(@setting.wine_discount_amount))/100).round(1)
    end

    total += total < Setting.order_delivery_amount && @delivery ? @delivery.price : 0




    cart_contains_not_only_events = false

    @items.each do |item|
      #  product = Product.find(cart_item.product.id)
      # current_item = @items.find { |t| t.product.id == item[:id].to_i }
      current_item = Product.find(item.product.id)
      if current_item.categories.root.name != "Events" and current_item.categories.root.name != "Wine Tours"
        cart_contains_not_only_events = true
        break
      end

    end



    #  if total > Setting.find(:first).order_delivery_amount and @delivery.bulk_order_price == 0
    #   @delivery.price = 0
    #  els
    if cart_contains_not_only_events
      @delivery = Delivery.find(self.delivery.id)
      total += @delivery.price
    else
      @delivery.price = 0
      total += @delivery.price
    end

    # if total > Setting.find(:first).order_delivery_amount and @delivery.bulk_order_price == 0
    #    @delivery.price = 0
    # else
    #  total += @delivery.price
    # end



    # total += @gift.price if @gift
    if self.gift.present? and !self.gift[:gift_option_id].blank?
      total += GiftOption.find(self.gift[:gift_option_id]).price
    end
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

