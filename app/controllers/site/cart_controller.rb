class Site::CartController < ApplicationController
  # before_filter :site_login_required, :only => [:gift_options,:update_gift]
  layout "site"

  def index
    @cupon = @cart.cupon
    @delivery = @cart.delivery

    @cart.gift = ""
    @buy_together_discount = @cart.buy_together_discount

  end

  def create
    #discounted_price = "0.0" ? product.product_prices.first.price : params[:discounted_price]
    #puts "####################discounted_price #{discounted_price}"
    #raise discounted_price and return
    created = @cart.create(product, quantity, params[:discounted_price])
    if created
      session[:free_delivery] = false
      if @cart.sub_total > Setting.order_delivery_amount and session[:free_delivery] == false
        @delivery = Delivery.find(12)
        @cart.delivery  = @delivery
        session[:free_delivery] = true
      end

      if logged_in?
        IncompletePurchase.find_or_create_by_email(current_user.email)
      end
      # @setting = Setting.find(:first)
      # if (product.quantity.to_i - quantity.to_i) < @setting.reorder_quantity.to_i and product.active
        # Commented by Sujith since UserName and Password of SMTP is not correct now
        #Notifier.deliver_reorder_quantity_notification(product,AppConfig.admin_email)
      # end

      status = "#{product.name.gsub("'", "\\'")} correctly added to your cart."
    else
      status = @cart.show_warnings
    end

    respond_to do |format|
      format.html do
        flash[:notice] = status
        redirect_back_or_default(site_cart_index_path)
      end

      format.js do
        render :update do |page|
          page["#cart"].html("")
          page["#cart"].html(render :partial => '/site/shared/cart')
          page["#promotion"].html(render :partial => '/site/shared/promotion')
          #page["#cart"].visual_effect :highlight, :startcolor => "#FFA800", :endcolor => "#c1d830"
          page << "alert('#{status}')"
        end
      end
    end
  end

  def update

    if @cart.update(params[:cart], params[:cupon][:code])
      if @cart.sub_total > Setting.order_delivery_amount and params[:delivery][:id].nil?

        @delivery = Delivery.find(12)
        delivery_id = @delivery
        session[:free_delivery] = true

        @cart.delivery = @delivery

      elsif @cart.sub_total < Setting.order_delivery_amount and params[:delivery][:id].nil?
        @delivery = (Delivery.find(params[:delivery][:id]) rescue Delivery.first)
        if @delivery.id == 11
          @delivery = Delivery.find(:first)
        end
        delivery_id = @delivery
        session[:free_delivery] = false
        @cart.delivery = @delivery

      else
        delivery_id = params[:delivery][:id]
        @delivery = Delivery.find(delivery_id)
        @cart.delivery  = @delivery

      end


      # @cart.update(params[:cart], params[:cupon][:code] )


      flash[:notice] = @cart.show_warnings
    else
      flash[:notice] = @cart.show_errors
    end
    @cupon = Cupon.find_by_code( params[:cupon][:code])


    # @setting = Setting.find(:first)
    # for cart_item in @cart.items
      #if cart_item.quantity < @setting.reorder_quantity
      # if (cart_item.product.quantity.to_i - cart_item.quantity.to_i) < @setting.reorder_quantity and cart_item.product.active
      #   Notifier.deliver_reorder_quantity_notification(cart_item.product,AppConfig.admin_email)
      # end
    # end
    unless  params[:cupon][:code].blank?
      if @cupon.nil? or @cupon.blank?
        flash[:notice] = "The promotional code is not valid,please enter a valid one."
      end
    end
    redirect_to :controller=>'cart',:action => :index
  end

  def empty
    session[:cart] = nil
    session[:free_delivery] = false
    if logged_in?
      @purchase = IncompletePurchase.find_by_email(current_user.email)
      unless @purchase.nil?
        Notifier.deliver_product_information(current_user,AppConfig.admin_email)
        @purchase.destroy
      end
    end
    redirect_to :action => :index
  end

  def continue_shopping
    redirect_back_or_default root_url
  end

  def destroy
    @cart.destroy(product_id)

    if logged_in?

      @purchase = IncompletePurchase.find_by_email(current_user.email)
      unless @purchase.nil?
        Notifier.deliver_product_information(current_user, AppConfig.admin_email)
        @purchase.destroy
      end
    end
    redirect_to :action => :index
  end

  def gift_options
    
    if @cart.sub_total < 10
      flash[:notice] = "Sorry, but there is a miminum order of £#{@setting.order_amount}"
      redirect_to :controller=>'cart',:action=>'index'
    end
    if !logged_in? and @cart.sub_total > 10
      session[:return_to] = '/site/cart/gift_options'
      redirect_to login_path
    end
    if logged_in?
      IncompletePurchase.find_or_create_by_email(current_user.email)
    end
  end

  def update_gift
    @cart.gift = params[:gift]
    redirect_to site_checkouts_url
  end

  private
  def quantity
    return params[:cart][:quantity] if params[:cart] && params[:cart][:quantity]
    return 1
  end

  def product_id
    return params[:product_id] if params[:product_id]
    return params[:recipe_id] if params[:recipe_id]
  end

  def product
    return Recipe.find(params[:recipe_id]) if params[:recipe_id]
    return Product.find(params[:product_id]) if params[:product_id]
  end
end

