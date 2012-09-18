class Admin::OrdersController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
     if params[:search]
      date=Date.new(params[:order_date]['(1i)'].to_i,params[:order_date]['(2i)'].to_i, params[:order_date]['(3i)'].to_i)
       @orders = Order.find(:all,:conditions=>['status_order_id LIKE ? AND (users.name  like ? OR users.login like ?)AND DATE(orders.created_at) <= ?',"%#{params[:status]}%","%#{params[:search_text]}%","%#{params[:search_text]}%",
       "#{date}"], :include => [:user, :status_order, :gift_option, :payment_method, :order_items], :order => "orders.created_at DESC").paginate(:page => params[:page], :per_page => 20)
  else
    @orders = Order.find(:all,:include => [:user, :status_order, :gift_option, :payment_method, :order_items], :order => "orders.created_at DESC").paginate(:page => params[:page], :per_page => 20)
end

  end

  def show
    @order = Order.find(params[:id])

    respond_to do |format|
#      format.dialog { render :partial => 'show' }
      format.html
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def destroy
    Order.find(params[:id]).destroy
    redirect_to :action => :index
  end

  def update
    order = Order.find(params[:id])

    if order.update_attributes(params[:order])
      flash[:notice] = 'Correctly saved'
    else
      flash[:notice] = order.show_errors
    end
    redirect_to :action => :index
  end

  def print_tasting
    @order = Order.find(params[:id])
    @tasting_notes = true
    render :layout => "print"

    #make_and_send_pdf("admin/orders/print_tasting", "Italyabroad_Tasting_Notes_#{@order.id}.pdf")
  end

  def print_invoice
    @order = Order.find(params[:id])
 #   send_data(generate_pdf(@order), :filename => "Invoice of Order# #{@order.id}.pdf", :type => "application/pdf")
    render :layout => "print"


 #    make_and_send_pdf("/admin/orders/#{@order.id}/print_invoice", "Italyabroad_Invoice_#{@order.id}.pdf")
  end

  def print_picking_list
    @order = Order.find(params[:id])

   render :layout => "print"

    #make_and_send_pdf("admin/orders/print_picking_list", "Italyabroad_Picking_List_#{@order.id}.pdf")
  end

  def delivery_details
    @order = Order.find(params[:id])
    if params[:submit] == "Deliver"
      @order = Order.find(params[:order_id])
        @order.update_attributes(:status_order_id=>5,:shipping_agency_id=>params[:agency],:consignment_no=>params[:consignment_no])
      Notifier.deliver_order_details_after_shipping(@order)
      flash[:notice] = 'The items are shipped'
      redirect_to admin_orders_path
   end
  end

  def generate_pdf(order)

    Prawn::Document.new do |pdf|


     # for order_item in order.order_items
      #  if (product = Product.find_by_name(order_item.name)) && product.is_wine?
          pdf.image  "#{RAILS_ROOT}/public/images/pdf_header.jpg",:width => 550, :height => 108
          pdf.bounding_box([0, 510], :width => 300, :height => 100) do
            pdf.text 'Sold To' + "\n" +
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
              end
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
        pdf.table (items)


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


def cancel_delivery_charge
  @order = Order.find(params[:id])
  @order.update_attribute(:delivery_name,"")
  @order.update_attribute(:delivery_price,0)
  redirect_to admin_orders_path
end
end

