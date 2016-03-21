class Site::CheckoutsController < ApplicationController



  before_filter :site_login_required
  before_filter :store_location
  after_filter :reset_session, :only => [:confirmed]


  #ssl_required :payment
  #ssl_required :all

  # UnComment this when site goes live
  # I think this is not working when the site is held as a sub domain of LegreenSolutions

  #Comment 2nd when we go Live
  #Now we are using this becuase https redirection is not working when site is sub domain of legreensolutions
    #ssl_allowed
    #ssl_required :all

    #ssl_allowed
    #ssl_required


  layout "site"

  def index
    unless @cart.valid?
      flash[:notice] = @cart.show_errors
      redirect_to site_cart_index_path
    end

    @ship_address = session[:ship_address] ||= current_user.default_ship_address
  end

  def confirm_address
    @ship_address = session[:ship_address] ||= current_user.ship_addresses.new(params[:ship_address])

    if @ship_address.valid?
       redirect_to payment_site_checkouts_path
    else
      flash[:notice] = @ship_address.show_errors
      redirect_to site_checkouts_path
   end
  end

  def payment
    if @cart.items.size == 0
      redirect_to site_cart_index_path
    end
    @payment_method = 2 #set default payment method to credit card
  end

  def paypal
  end

  def confirmed
    if @cart.items.size == 0
      redirect_to site_cart_index_path
    end
    @order = Order.find(:last,:conditions=>['user_id=?',current_user.id])
    @was_admin = false
    if session[:previous_admin_id]
      @was_admin = true
    end  
    revert_session
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

