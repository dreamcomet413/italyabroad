class Admin::CuponsController < ApplicationController
  #  auto_complete_for :product, :name, :limit => 15, :order => 'created_at DESC'
  before_filter :admin_login_required
  layout "admin"

  def index
    @cupons = Cupon.all.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @cupon = Cupon.new
    @cupon.code = ActivePassword.new

    respond_to do |format|
      #      format.dialog { render :partial => 'new' }
      format.html
    end
  end

  def edit
    @cupon = Cupon.find(params[:id])
    @products = @cupon.products.find(:all)
   if @products.empty?
     @products = Product.all
   end
    respond_to do |format|
      #      format.dialog { render :partial => 'edit' }
      format.html
    end
  end

  def create
    @cupon = Cupon.new(params[:cupon])
    if @cupon.save
      flash[:alert] = "Cupon is created successfully"
    else
      flash[:notice] = @cupon.show_errors
    end

    redirect_to :action => :index
  end

  def update

    @cupon = Cupon.find(params[:id])
    if @cupon.update_attributes(params[:cupon])
      flash[:alert] = "Cupon is updated successfully"
    else
      flash[:notice] = @cupon.show_errors
    end
    redirect_to :action => :index

  end

  def destroy
    Cupon.find(params[:id]).destroy
    flash[:notice] = "Cupon is deleted successfully"
    redirect_to :action => :index
  end

  def product_list
    @products = Product.find(:all, :conditions => ['name LIKE ?', "#{params[:search]}%"], :limit => 15, :order => "name ASC")
    render :update do |page|
      page.replace_html 'search_result', :partial => 'product_list', :collections => @products
    end
  end
end

