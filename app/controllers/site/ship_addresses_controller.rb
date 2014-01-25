class Site::ShipAddressesController < ApplicationController
  before_filter :site_login_required

  def new

    address_id = params[:ship_address_id].to_i
    if address_id == -1
      @ship_address = current_user.ship_addresses.new
      @ship_address.is_new = true

    elsif address_id > 0
      @ship_address = current_user.ship_addresses.find(address_id)
      @ship_address.is_new = false
    else
      @ship_address = current_user.default_ship_address
      @ship_address.is_new = false
    end

    session[:ship_address] = @ship_address

    respond_to do |format|
      format.js {
        render :update do |page|
          page[".notice"].html("")
          page["#shipping_address"].html("")
          page["#shipping_address"].html( render :partial => "ship_address", :locals => {:ship_address => @ship_address} )
        end
      }
      format.html { redirect_to site_checkouts_path }
    end
  end

  def create
    @ship_address = current_user.ship_addresses.new(params[:ship_address])

    if @ship_address.save
      session[:ship_address] = @ship_address
      flash[:notice] = "The new address has been created successfully."
    else
      flash[:notice] = @ship_address.show_errors
    end

    respond_to do |format|
      session[:ship_address] = @ship_address
      @ship_address.is_new = true
      format.html { redirect_to site_checkouts_path }
    end
  end

  def destroy
    @ship_address = current_user.ship_addresses.find(params[:id])
    respond_to do |format|
      format.js {
        render :update do |page|
          if @ship_address != current_user.default_ship_address and @ship_address.destroy
            page[".notice"].html("")
            page["#shipping_address"].html("")
            page["#ship_address_id"].val("0")
            page["#shipping_address"].html(render :partial => "ship_address", :locals => {:ship_address => current_user.default_ship_address} )
            session[:ship_address] = nil
            page.reload
          else
            page[".notice"].html("<p>Shipping Address can not be deleted.</p>")
          end
        end
      }
    end
  end
end

