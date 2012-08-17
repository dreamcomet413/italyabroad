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

    created = @cart.create(product,quantity)
    if created
         @setting = Setting.find(:first)
          if product.quantity.to_i - quantity.to_i < @setting.reorder_quantity.to_i
            # Commented by Sujith since UserName and Password of SMTP is not correct now
            logger.info " product.quantity.to_i - quantity.to_i < @setting.reorder_quantity.to_i => #{product.quantity.to_i} - #{quantity.to_i} < #{@setting.reorder_quantity.to_i}"
            Notifier.deliver_reorder_quantity_notification(product,AppConfig.admin_email)
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
          page.replace_html 'cart', :partial => "/site/shared/cart"
          page.replace_html 'promotion', :partial => "/site/shared/promotion"
          page.visual_effect :highlight, 'cart', :startcolor => "#FFA800", :endcolor => "#c1d830"
          page << "alert('#{status}')"
        end
      end
    end
  end

  def update

    if @cart.update(params[:cart], params[:cupon][:code], params[:delivery][:id])

      flash[:notice] = @cart.show_warnings
    else
      flash[:notice] = @cart.show_errors
    end
    @cupon = Cupon.find_by_code( params[:cupon][:code])


    @setting = Setting.find(:first)
   for cart_item in @cart.items
          #if cart_item.quantity < @setting.reorder_quantity
          if (cart_item.product.quantity.to_i - cart_item.quantity.to_i) < @setting.reorder_quantity
            Notifier.deliver_reorder_quantity_notification(cart_item.product,AppConfig.admin_email)
          end
   end
  unless  params[:cupon][:code].blank?
    if @cupon.nil? or @cupon.blank?
        flash[:notice] = "The promotional code is not valid,please enter a valid one."
      end
  end
    redirect_to :action => :index
  end

  def empty
    session[:cart] = nil
    redirect_to :action => :index
  end

  def continue_shopping
    redirect_back_or_default root_url
  end

  def destroy
    @cart.destroy(product_id)
    redirect_to :action => :index
  end

  def gift_options
    session[:return_to] = '/site/cart/gift_options'
    if @cart.sub_total < 10
      flash[:notice] = "Sorry, but there is a miminum order of £#{@setting.order_amount}"
      redirect_to :controller=>'cart',:action=>'index'
    end
    if !logged_in? and @cart.sub_total > 10
      redirect_to login_path
    end
  end

  def update_gift
      @cart.gift = params[:gift]
      redirect_to checkouts_url
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

