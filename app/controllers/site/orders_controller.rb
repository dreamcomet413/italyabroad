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
          points_used = 0
          unless params[:points_to_be_used].nil?
            if params[:total_points].to_f > params[:points_to_be_used].to_f and  (@cart.total - (params[:points_to_be_used].to_f * Setting.find(:first).points_to_pound) >= 0)
                total_amount = (@cart.total) - (params[:points_to_be_used].to_f * Setting.find(:first).points_to_pound)
             points_used = params[:points_to_be_used]
            # new_order.update_attributes(:points_used => params[:points_to_be_used])
            else
              points_used = (@cart.total)/ Setting.find(:first).points_to_pound
             # new_order.update_attributes(:points_used =>(@cart.total)/ Setting.find(:first).points_to_pound )
             total_amount = 0
            end
           else

             total_amount = @cart.total
           end
           Notifier.deliver_new_order_placed(@order,current_user,AppConfig.admin_email)
          if production
            gateway = ActiveMerchant::Billing::SagePayGateway.new(:login => @payment_method.vendor)

         #   response = gateway.purchase(@cart.total*100, @credit_card, :order_id => "#{order.id}", :address => { :address1 => current_user.address, :zip => current_user.cap })
          # modified for loyalty system


         response = gateway.purchase(total_amount, @credit_card, :order_id => "#{order.id}", :address => { :address1 => current_user.address, :zip => current_user.cap })

          end

          if (!response.nil? && response.success?) or !production
           # new_order.update_attributes(:paid => true)
          #  new_order.update_attributes(:points_used => points_used)
           @order.update_attributes(:paid => true,:points_used => points_used)
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
        unless params[:points_to_be_used].nil?
            if params[:total_points].to_f > params[:points_to_be_used].to_f and  (@cart.total - (params[:points_to_be_used].to_f * Setting.find(:first).points_to_pound) >= 0)
                total_amount = (@cart.total) - (params[:points_to_be_used].to_f * Setting.find(:first).points_to_pound)
             points_used = params[:points_to_be_used]
            # new_order.update_attributes(:points_used => params[:points_to_be_used])
            else
              points_used = (@cart.total)/ Setting.find(:first).points_to_pound
             # new_order.update_attributes(:points_used =>(@cart.total)/ Setting.find(:first).points_to_pound )
             total_amount = 0
            end
           else
             total_amount = @cart.total
           end
        Notifier.deliver_new_order_placed(@order,current_user,AppConfig.admin_email)
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
    send_data(generate_pdf(@order), :filename => "Invoice of Order# #{@order.id}.pdf", :type => "application/pdf")
  end

  def show_order_details
    @orders = current_user.orders.all(:order => "created_at DESC")
    respond_to do |format|
      format.html { render :layout => 'site' }
    end
    session[:return_url] = request.request_uri

  end

  def write_review
    render :partial => "site/reviews/write_review",:locals=>{:product_id=>params[:id],:order_id=>params[:order_id]}

  end

 def review
      @review = Review.create!(:name=>params[:name],:description=>params[:description],:reviewer_id=>params[:product_id],:user_id=>current_user.id,:reviewer_type=>'Product',:score=>params[:score])
      Notifier.deliver_new_review_added(Product.find(@review.reviewer_id),current_user,AppConfig.admin_email,@review)
      @order = current_user.orders.find(params[:order_id])
      @order_item = @order.order_items.find_by_product_id(params[:product_id])
      @order_item.update_attribute('reviewed',true)
      flash[:notice] = 'Review correctly published!'
      redirect_to session[:return_url]
  end


  private

  def create_order_items
    for item in @cart.items
      @order.order_items.create( :name => item.product.name,
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

    Prawn::Document.new do |pdf|


     # for order_item in order.order_items
      #  if (product = Product.find_by_name(order_item.name)) && product.is_wine?
          pdf.image  "#{RAILS_ROOT}/public/images/pdf_tasting_header.png",:width => 550, :height => 108
          pdf.bounding_box([0, 510], :width => 300, :height => 100) do
            pdt.text 'Sold To \n' +
            order.user.name + " " + order.user.surname  + "\n" +
              order.user.address  + "\n" +
              order.user.address_2 + "\n" +
              order.user.city  + "\n"
          end
           if order.different_shipping_address
              pdf.bounding_box([200, 510], :width => 300, :height => 100) do
              pdf.text order.ship_name + "\n" +
              order.ship_address  + "\n" +
              order.ship_address_2 + "\n" +
              order.ship_city  + "\n"+
              order.ship_cap + "\n" +
              order.ship_country + "\n"
          else
              pdf.bounding_box([200, 510], :width => 300, :height => 100) do
             pdf.text order.user.name + " " + order.user.surname  + "\n" +
              order.user.address  + "\n" +
              order.user.address_2 + "\n" +
              order.user.city  + "\n"
              order.user.cap + "\n" +
              order.user.country + "\n"
          end
          end
        pdf.text "Order Number: #{ @order.id}"  + "\n"
		    pdf.text "Order Date:  #{order.created_at.strftime('%d/%m/%Y')}"  + "\n"
		    pdf.text "Invoice Date:  #{Time.now.strftime('%d/%m/%Y')}"
         items = order.order_items.map do |item|
          [
          item.product_code ,
          item.quantity,
          item.name,
          "£" + item.vat.to_s,
           item.rate,
          "£" + item.price.to_s,
          "£" + item.total.to_s
        ]
        end
        pdf.move_down 10
        pdf.table items


      #  end
     # end
     pdf.move_down 10
     pdf.text "Sub Total: £#{ @order.sub_total}"  + "\n"
     if @order.sub_total < Setting.order_delivery_amount
      pdf.text "Sub Total: #{ order.delivery_name} : £#{order.delivery_price} \n"
    end
    unless order.cupon_code.blank?
      pdf.text "Coupon: #{ order.cupon_price}"  + "\n"
    end
    if order.gift_option && order.gift_option.price > 0
      pdf.text "Wrapping option: #{order.gift_option.name} : #{order.gift_option.price} \n"
    end
    total =  order.total - (order.points_used * Setting.find(:first).points_to_pound)
      pdf.text "Total: £#{total} \n"
    pdf.move_down 70
    #pdf.image "#{RAILS_ROOT}/public/images/pdf_tasting_footer.png",:position => :center
   pdf.text "<font size='8'>Don't forget to write your review for the produces purchased.
			Let our users know what you think about our produces and if you are the first to write the review you will also receive £5 discount on your next purchase.</font>", :inline_format => true

    end.render
  end
end

