class Site::CartController < ApplicationController
  # before_filter :site_login_required, :only => [:gift_options,:update_gift]
  layout "site"

  # skip_before_filter  :verify_authenticity_token, :only => [:update]

  autocomplete :user, :name, :display_value => :full_name, :extra_data => [:surname ]

  def index
    # debugger
    @cupon = @cart.cupon
    @delivery = @cart.delivery

    @cart.gift = ""
    @buy_together_discount = @cart.buy_together_discount

    @cart.valid?
  end

  def create
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
      
      status = "#{product.name.gsub("'", "\\'")} correctly added to your cart."
    else
      status = @cart.show_warnings
    end

    respond_to do |format|
      format.html do
        flash[:notice] = status
        redirect_back_or_default(cart_index_path)
      end

      format.js do
        render :update do |page|
          page[".cart-top"].html("")
          page[".items_count"].html(@cart.items.size.to_i)
          page[".cart-top"].html(render :partial => '/site/shared/cart')
          page[".free-delivery"].html(render :partial => '/site/shared/promotion')
          page << "alert('#{j  status}')"
        end
      end
    end
  end

  def update
      same_delivery = @cart.delivery.id == params[:delivery][:id].to_i rescue false
      # render :text => same_delivery
      # return 
      if @cart.update(params[:cart], params[:cupon][:code])
        if @cart.sub_total > Setting.order_delivery_amount and same_delivery and session[:free_delivery] == false

          @delivery = Delivery.find(12)
          delivery_id = @delivery
          session[:free_delivery] = true

          @cart.delivery = @delivery

        elsif @cart.sub_total < Setting.order_delivery_amount and same_delivery and session[:free_delivery] == true
          @delivery = (Delivery.find(params[:delivery][:id]) rescue Delivery.first)
          if @delivery.id == 12
            @delivery = Delivery.find(:first)
          end
          delivery_id = @delivery
          session[:free_delivery] = false
          @cart.delivery = @delivery

        else
          delivery_id = params[:delivery][:id] rescue nil
          @delivery = Delivery.find(delivery_id) rescue Delivery.first
          @cart.delivery  = @delivery

        end
        flash[:notice] = @cart.show_warnings
        flash[:cupon_notice] = @cart.show_cupon_warnings
      else
        flash[:notice] = @cart.show_errors
        flash[:cupon_notice] = @cart.show_cupon_errors
      end
      @cupon = Cupon.find_by_code( params[:cupon][:code])

      unless  params[:cupon][:code].blank?
        if @cupon.nil? or @cupon.blank?
          flash[:cupon_notice] = "The promotional code is not valid,please enter a valid one."
        end
      end
      # debugger
    redirect_to :controller=>'cart',:action => :index
  end

  def empty
    session[:cart] = nil
    session[:free_delivery] = false
    if logged_in?
      @purchase = IncompletePurchase.find_by_email(current_user.email)
      unless @purchase.nil?
        Notifier.product_information(current_user,AppConfig.admin_email).deliver
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
        Notifier.product_information(current_user, AppConfig.admin_email).deliver
        @purchase.destroy
      end
    end
    redirect_to :action => :index
  end

  def gift_options
    puts @cart
    if @cart.sub_total < 10
      flash[:notice] = "Sorry, but there is a miminum order of £#{@setting.order_amount}"
      redirect_to :controller=>'cart',:action=>'index'
    end
    if !logged_in? and @cart.sub_total > 10
      session[:return_to] = '/cart/gift_options'
      redirect_to login_path
    end
    if logged_in?
      IncompletePurchase.find_or_create_by_email(current_user.email)
    end
  end

  def user_select
    if request.post?
      if params[:reset_user_id]
        @user = User.find(params[:reset_user_id])
        revert_session
      else
        @user = User.find(params[:user_id])
        switch_session
      end
      redirect_to '/cart/gift_options'
    end
  end

  def update_gift
    @cart.gift = params[:gift]
    redirect_to checkouts_url
  end

  private
  def quantity
    if params[:quantity]
      return params[:quantity]
    elsif params[:cart] && params[:cart][:quantity]
      return params[:cart][:quantity] 
    else
      return 1
    end
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

