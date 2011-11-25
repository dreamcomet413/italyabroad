class Admin::GiftOptionsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @gift_options = GiftOption.all.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @gift_option = GiftOption.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @gift_option = GiftOption.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def create
    gift_option = GiftOption.new(params[:gift_option])

    if gift_option.save
      flash[:notice] = "Gift options is created successfully"
    else
      flash[:notice] = gift_option.show_errors
    end

    redirect_to :action => :index
  end

  def update
    gift_option = GiftOption.find(params[:id])
    return_data = { :success => false, :msg => '', :data => {} }    
    
    if gift_option.update_attributes(params[:gift_option])
      flash[:notice] = 'Correctly saved'
    else
      flash[:notice] = gift_option.show_errors
    end
    
    redirect_to :action => :index
  end

  def destroy
    GiftOption.find(params[:id]).destroy
    redirect_to :action => :index
  end
end

