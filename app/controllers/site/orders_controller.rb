class Site::OrdersController < ApplicationController
  before_filter :site_login_required
  before_filter :store_location, :only => [:show]


  #Uncomment the IF part when we go for production
  #ssl_required :create if RAILS_ENV == "production"
  #ssl_allowed

  # Since this is being done through /etc/httpd/conf/extra/virtual.conf
  # Now ssl_required is not used

  require "prawn"

  def index
    @orders = current_user.orders.where("id is not null").order("created_at DESC").paginate(:page => params[:page], :per_page => 10)

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
  session[:credit_card_type] = params[:credit_card][:type]
  session[:card_first_name] = params[:credit_card][:first_name]
  session[:card_last_name] = params[:credit_card][:last_name]
  session[:credit_card_number] = params[:credit_card][:number]
  session[:card_expiry_month] = params[:credit_card][:month].to_i
  session[:card_expiry_year] = params[:credit_card][:year].to_i
  session[:card_verification_value] = params[:credit_card][:verification_value].to_i

  unless params[:accept].blank?
    @payment_method = PaymentMethod.find(params[:payment_method])


    total_amount, points_used = find_total_and_points_used(params[:points_to_be_used],
                                                        @cart.total, params[:points_to_be_used], params[:total_points])

    if (@payment_method && !@payment_method.external) or total_amount == 0      #### 0001
      production = RAILS_ENV == "production"
      @credit_card = ActiveMerchant::Billing::CreditCard.new(params[:credit_card])

     # @sujith=true

     if (@credit_card.valid? or !production) or total_amount == 0               #### 0002

        new_order
        saved = @order.save

        if saved                                                                            #### 0003
          create_order_items
          #total_amount, points_used = find_total_and_points_used(params[:points_to_be_used], @cart.total, params[:points_to_be_used], params[:total_points])
          @incomplete_purchase = IncompletePurchase.find_by_email(current_user.email)
          @incomplete_purchase.destroy



          if production and total_amount > 0                                                          #### 0004

              gateway = ActiveMerchant::Billing::SagePayGateway.new(:login =>'italyabroad')
              shipping_address = assign_shipping_address(@order.different_shipping_address, @order, current_user)

              response = gateway.purchase(total_amount*100, @credit_card, :order_id=>"#{@order.id}",
              :billing_address => {
                :name=>current_user.name.to_s + " " + current_user.surname.to_s,
                :address1=>current_user.address,  :city=>current_user.city, :state=>current_user.province,
                :country=>current_user.country, :zip=>current_user.cap},
              :shipping_address=>{
                :name=>shipping_address["name"].to_s + " " + shipping_address["name"].to_s,
                :address1=>shipping_address["address1"], :city=>shipping_address["city"],
                :state=>shipping_address["state"], :country=>shipping_address["country"], :zip=>shipping_address["zip"]}
               )

          end   #END OF IF PRODUCTION                                                   #### 0004
                #logger.info "TESTING_SITE__  RESULT #{response.success?}"

          if (!response.nil? && response.success?) or total_amount == 0 or !production
                logger.info "entered response block"
                if  @cart.cupon
                    logger.info "44444"

                    @cupon = Cupon.find_by_code(@cart.cupon.code)
                    if @cupon.created_by_admin
                      @cupon.no_of_times_used =  @cupon.no_of_times_used + 1
                      if  @cupon.no_of_times == @cupon.no_of_times_used
                        @cupon.update_attribute('active',false)
                      end
                    else
                      @cupon.update_attribute('active',false)
                    end
                    @order.update_attributes(:cupon_code=>@cart.cupon.code,:cupon_price=>@cupon.price)

                 end
                  @order.update_attributes(:paid => true, :points_used => points_used, :status_order_id => 3)
                   if @order.status_order_id == 3
                     logger.info "venu"
                      Notifier.deliver_new_order_placed(@order,current_user,AppConfig.admin_email)
                      Notifier.deliver_new_order(@order)
                  end
                  # => :status_order_id => 3 ORDER COMPLETED
                  session[:card_last_name] = ""
                  redirect_to confirmed_checkouts_path
            else

                  if request.remote_ip != "127.0.0.1"
                    flash[:notice] = response.message
                    logger.info request.remote_ip
                  else
                    flash[:notice] = "Payment not complete"
                  end

                  redirect_to payment_checkouts_path


              end

        else
        #Unable to save Order
            logger.info "Unable to save order##########################################################"
            flash[:notice] = @order.errors

        end   #End of if order.save


      else
        # END OF IF @credit_card.valid? or !production
        # Invalid Credit Card
        logger.info " CREDIT CARD NOT VALID ##########################################################"
        flash[:notice] = @credit_card.errors
        redirect_to payment_checkouts_path
      end


    else

      logger.info "NOT CREDIT CARD ...!"


      #ELSE of if @payment_method && !@payment_method.external
      # Payment is outside site/not online.
      new_order
      saved = @order.save



      if saved
        logger.info "SAVED ....!"
        create_order_items
        #total_amount, points_used = find_total_and_points_used(params[:points_to_be_used], @cart.total, params[:points_to_be_used], params[:total_points])

      # added by indu on dec 12 2012
         if  @cart.cupon
                    logger.info "55555555"

                    @cupon = Cupon.find_by_code(@cart.cupon.code)
                    if @cupon.created_by_admin
                      @cupon.no_of_times_used =  @cupon.no_of_times_used + 1
                      if  @cupon.no_of_times == @cupon.no_of_times_used
                        @cupon.update_attribute('active',false)
                      end
                    else
                      @cupon.update_attribute('active',false)
                    end
                    @order.update_attributes(:cupon_code=>@cart.cupon.code,:cupon_price=>@cupon.price)

                 end
       
        if @order.status_order_id == 3
           Notifier.deliver_new_order_placed(@order,current_user,AppConfig.admin_email)
        end
        @incomplete_purchase = IncompletePurchase.find_by_email(current_user.email)
        @incomplete_purchase.destroy
      end # END OF if saved
      # redirect_to paypal_checkouts_path(:id => new_order.id)
    end


  else
    # else of accept terms and conditions
    flash[:notice] = 'Please accept terms and conditions'
    redirect_to :controller=>'checkouts',:action=>'payment'

  end

end

  def invoice
    @order = current_user.orders.find(params[:id])

    respond_to do |format|
      format.html { render :layout => 'site' }
    end
  end

  def download_pdf
    @order = Order.find(params[:id])
    @tasting_notes = true
    render :layout => "print"
    # send_data(generate_pdf(@order), :filename => "Invoice of Order# #{@order.id}.pdf", :type => "application/pdf")
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
     # :gift_option_id             => @cart.gift.gift_option_id,
     :gift_option_id             => @cart.gift[:gift_option_id].to_i,
     # :gift_note                  => @cart.gift.note,
     :gift_note                  => @cart.gift[:note],
      :different_shipping_address => session[:ship_address].is_new,
      :ship_name                  => session[:ship_address].name,
      :ship_address               => session[:ship_address].address,
      :ship_address_2             => session[:ship_address].address_2,
      :ship_city                  => session[:ship_address].city,
      :ship_country               => session[:ship_address].country,
      :ship_cap                   => session[:ship_address].cap,
      :ship_telephone             => session[:ship_address].telephone,
      :note                       => session[:ship_address].note,
      :payment_method_id          => @payment_method.id,
      :cupon_code                 =>@cart.cupon
    )
  end

#      :surname                    => session[:ship_address].surname,


  def generate_pdf(order)
    Prawn::Document.new do |pdf|

       # for order_item in order.order_items
      #  if (product = Product.find_by_name(order_item.name)) && product.is_wine?
          pdf.image  "#{RAILS_ROOT}/public/images/pdf_tasting_header.png",:width => 550, :height => 108
          pdf.bounding_box([0, 510], :width => 300, :height => 100) do
            #pdt.text 'Sold To \n' +
            pdf.text 'Sold To \n' +
            order.user.name.to_s + " " + order.user.surname.to_s  + "\n" +
              order.user.address.to_s  + "\n" +
              order.user.address_2.to_s + "\n" +
              order.user.city.to_s  + "\n"
          end
          if order.different_shipping_address
              pdf.bounding_box([200, 510], :width => 300, :height => 100) do
                pdf.text order.ship_name + "\n" +
                order.ship_address  + "\n" +
                order.ship_address_2 + "\n" +
                order.ship_city  + "\n"+
                order.ship_cap + "\n" +
                order.ship_country + "\n"
              end
          else
              pdf.bounding_box([200, 510], :width => 300, :height => 100) do
                pdf.text order.user.name.to_s + " " + order.user.surname.to_s  + "\n" +
                order.user.address.to_s  + "\n" +
                order.user.address_2.to_s + "\n" +
                order.user.city.to_s  + "\n"
                order.user.cap.to_s + "\n" +
                order.user.country.to_s + "\n"
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

    if @order.points_used > 0
      pdf.text "Points Used( #{order.points_used}): £#{order.points_used * Setting.find(:first).points_to_pound}"
    end




    total =  order.total - (order.points_used * Setting.find(:first).points_to_pound)
      pdf.text "Total: £#{total} \n"
    pdf.move_down 70
    #pdf.image "#{RAILS_ROOT}/public/images/pdf_tasting_footer.png",:position => :center
   pdf.text "<font size='8'>Don't forget to write your review for the produces purchased.
			Let our users know what you think about our produces and if you are the first to write the review you will also receive £5 discount on your next purchase.</font>", :inline_format => true


    end.render
  end

  def find_total_and_points_used(buy_with_points, cart_total, points_to_be_used, total_points)
    # finds the total amount based on points and stores the points used(if any) in order
          unless buy_with_points.nil?

                      total_amount = cart_total
                      #find correct points used even if the user enters -ve and wrong value for points
                      points_used = find_points_used(points_to_be_used, total_points)

                      equivalent_credit = points_used.to_f * Setting.find(:first).points_to_pound
                      # normal, available points used
                      if total_amount > equivalent_credit
                          total_amount = total_amount - equivalent_credit
                      else  # too many points in credit
                          total_amount = 0    # no need to pay because of previous credits accrued
                          points_used = cart_total / Setting.find(:first).points_to_pound
                      end
          else  # no points entered

             total_amount = cart_total

          end   # end of points

  return total_amount, points_used

  end




  def find_points_used(points_to_be_used,total_points)
    points_to_be_used = 0 if points_to_be_used.to_f < 0
    points_to_be_used = total_points.to_f if total_points.to_f < points_to_be_used.to_f
    points_to_be_used
  end


  def  assign_shipping_address(ship_to_different_location, order, this_user)
  # modified for loyalty system
  # Sujith - state is assigned to zip code because the zip was not being captured

     if ship_to_different_location
            shipping_address = {"name"=>order.ship_name, "address1"=>@order.ship_address,
                                 "city"=>order.ship_city,
                                 "state"=>order.ship_cap,
                                 "country"=>order.ship_country,
                                 "zip"=>order.ship_cap
            }
     else
             shipping_address = {"name"=>this_user.name.to_s + current_user.surname.to_s,
                                "address1"=>this_user.address,
                                 "city"=>this_user.city,
                                 "state"=>this_user.province,
                                 "country"=>this_user.country,
                                 "zip"=>this_user.cap
                                 }
     end
    return shipping_address
   end

end

