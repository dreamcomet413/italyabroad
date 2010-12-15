class Admin::ShippingAgenciesController < ApplicationController
   layout "admin"
  before_filter :admin_login_required

  def index
    @shipping_agencies = ShippingAgency.find(:all)
  end
 def new
    @shipping_agency = ShippingAgency.new

    respond_to do |format|
      format.html
    end
  end
def edit
    @shipping_agency = ShippingAgency.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
   def destroy
    @shipping_agency.find_by_id(params[:id]).destroy
    redirect_to :action => :index
  end
   def create
    @shipping_agency = ShippingAgency.new(params[:shipping_agency])

    if @shipping_agency.save
      redirect_to admin_shipping_agencies_path
    else
      flash[:notice] = @shipping_agency.show_errors
      render :action => :new
    end
  end

  def update
    @shipping_agency = ShippingAgency.find(params[:id])
      if @shipping_agency.update_attributes(params[:shipping_agency])
        flash[:notice] = "Shipping Agency updated successfully"
        redirect_to admin_shipping_agencies_path
      else
         render :action => "edit"
      end
  end
end

