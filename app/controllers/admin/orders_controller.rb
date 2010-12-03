class Admin::OrdersController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @orders = Order.find(:all, :include => [:user, :status_order, :gift_option, :payment_method, :order_items], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
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
end
