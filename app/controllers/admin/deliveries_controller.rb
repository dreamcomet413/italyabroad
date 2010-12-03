class Admin::DeliveriesController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @deliveries = Delivery.all.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @delivery = Delivery.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @delivery = Delivery.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  def create
    @delivery = Delivery.new(params[:delivery])
    
    if @delivery.save
      flash[:notice] = "Delivery created successfully"
    else
      flash[:notice] = @delivery.show_errors
    end
    
    redirect_to :action => :index
  end

  def update
    @delivery = Delivery.find(params[:id])
    
    if @delivery.update_attributes(params[:delivery])
      flash[:notice] = "Delivery updated successfully"
    else
      flash[:notice] = @delivery.show_errors
    end
    
    redirect_to :action => :index
  end

  def destroy
    Delivery.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
