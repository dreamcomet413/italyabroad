class Admin::OrdersController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
     if params[:search]
      date=Date.new(params[:order_date]['(1i)'].to_i,params[:order_date]['(2i)'].to_i, params[:order_date]['(3i)'].to_i)
       @orders = Order.find(:all,:conditions=>['status_order_id LIKE ? AND (users.name  like ? OR users.login like ?)AND DATE(orders.created_at) <= ?',"%#{params[:status]}%","%#{params[:search_text]}%","%#{params[:search_text]}%",
       "#{date}"], :include => [:user, :status_order, :gift_option, :payment_method, :order_items], :order => "orders.created_at DESC").paginate(:page => params[:page], :per_page => 10)
  else
    @orders = Order.find(:all,:include => [:user, :status_order, :gift_option, :payment_method, :order_items], :order => "orders.created_at DESC").paginate(:page => params[:page], :per_page => 10)
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
      Notifier.deliver_order_details_after_shipping(@order)
      @order.update_attributes(:status_order_id=>5,:shipping_agency_id=>params[:agency])
      flash[:notice] = 'The items are shipped'
      redirect_to admin_orders_path
   end
  end

end

