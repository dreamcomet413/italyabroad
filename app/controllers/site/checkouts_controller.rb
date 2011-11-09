class Site::CheckoutsController < ApplicationController
  before_filter :site_login_required
  before_filter :store_location
  after_filter :reset_session, :only => [:confirmed]

  layout "site"

  def index
    unless @cart.valid?
      flash[:notice] = @cart.show_errors
      redirect_to cart_index_path
    end

    @ship_address = session[:ship_address] ||= current_user.default_ship_address
  end

  def confirm_address
    @ship_address = session[:ship_address] ||= current_user.ship_addresses.new(params[:ship_address])

    if @ship_address.valid?
      redirect_to payment_checkouts_path
    else
      flash[:notice] = @ship_address.show_errors
      redirect_to checkouts_path
    end
  end

  def payment

    @payment_method = 2 #set default payment method to credit card
  end

  def paypal
  end

  def confirmed
  end

  def order_confirmation
   if request.post?
    unless params[:accept].blank?
      redirect_to :controller=>'site/checkouts',:action=>'payment'
    else
      flash[:notice] = 'Please accept terms and conditions'
      #flash[:alert] = "Please accept terms and conditions"
      #redirect_to :controller=>'checkouts',:action=>'payment'
    end
 end
  end

  private
  def reset_session
    session[:ship_address] = nil
    session[:cart] = nil
  end
end

