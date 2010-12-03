class Site::OrdersController < ApplicationController
  before_filter :site_login_required
  before_filter :store_location, :only => [:show]

  ssl_required :create if RAILS_ENV == "production"
  ssl_allowed 
  require "prawn"

  def index
    @orders = current_user.orders.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
    
    respond_to do |format|
      format.html { render :layout => 'site' }
    end
  end

  def show
    store_location

    @order = current_user.orders.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => 'site' }
    end
  end

  def new
    payment_method = params[:payment_method].to_i

    respond_to do |format|
      if payment_method == 2
        format.js { render :partial => 'cc_form' }
      else
        format.js { render :text => nil }
      end
    end
  end
  
  def create
    @payment_method = PaymentMethod.find(params[:payment_method])
    
    if @payment_method && !@payment_method.external
      production = RAILS_ENV == "production"
      @credit_card = ActiveMerchant::Billing::CreditCard.new(params[:credit_card])
      if @credit_card.valid? or !production
        new_order
        saved = @order.save
        if saved
          create_order_items

          if production
            gateway = ActiveMerchant::Billing::SagePayGateway.new(:login => @payment_method.vendor)
            response = gateway.purchase(@cart.total*100, @credit_card, :order_id => "#{order.id}", :address => { :address1 => current_user.address, :zip => current_user.cap })
          end
          
          if (!response.nil? && response.success?) or !production
            new_order.update_attributes(:paid => true)
            redirect_to confirmed_checkouts_path
          else
            flash[:notice] = response.message
            redirect_to payment_checkouts_path
          end
        else
          flash[:notice] = @order.errors
        end
      else
        flash[:notice] = @credit_card.errors
        redirect_to payment_checkouts_path
      end
    else
      new_order
      saved = @order.save
      if saved
        create_order_items
      end
      redirect_to paypal_checkouts_path(:id => new_order.id)
    end
  end

  def invoice    
    @order = current_user.orders.find(params[:id])

    respond_to do |format|
      format.html { render :layout => 'site' }
    end
  end

  def download_pdf
    puts params[:id]
    @order = Order.find(params[:id])
    @tasting_notes = true
    send_data(generate_pdf(@order), :filename => "Tasting-Notes.pdf", :type => "application/pdf")
  end


  
  private
  
  def create_order_items
    for item in @cart.items
      @order.order_items.create( :name         => item.product.name,
        :price        => item.price,
        :rate         => item.product.rate,
        :vat          => item.vat,
        :product_code => item.product.code,
        :quantity     => item.quantity,
        :product      => item.product)
      item.product.update_attributes(:quantity => item.product.quantity-item.quantity)
    end
  end
  
  def new_order
    @order = current_user.orders.new(
      :status_order_id            => 1,
      :delivery_name              => @cart.delivery.name,
      :delivery_price             => @cart.delivery.price,
      :ship_a_gift                => current_user.ship_a_gift,
      :gift_option_id             => @cart.gift.gift_option_id,
      :gift_note                  => @cart.gift.note,
      :different_shipping_address => session[:ship_address].is_new,
      :ship_name                  => session[:ship_address].name,
      :ship_address               => session[:ship_address].address,
      :ship_address_2             => session[:ship_address].address_2,
      :ship_city                  => session[:ship_address].city,
      :ship_country               => session[:ship_address].country,
      :ship_cap                   => session[:ship_address].cap,
      :ship_telephone             => session[:ship_address].telephone,
      :note                       => session[:ship_address].note,
      :payment_method_id          => @payment_method.id
    )
  end

  def generate_pdf(order)

    Prawn::Document.new do
      for order_item in order.order_items
        if (product = Product.find_by_name(order_item.name)) && product.is_wine?
          image  "#{RAILS_ROOT}/public/images/pdf_tasting_header.png",:width => 550, :height => 108
          move_down 70
          text product.name,:align => :center
          text product.vintage, :align => :center
          text product.description.gsub("\n","<br />")
          move_down 40
          image "#{RAILS_ROOT}/public/images/pdf_tasting_footer.png",:position => :center

        end
      end
    end.render
  end
end
