class Admin::GrapesController < ApplicationController
  before_filter :admin_login_required
  layout "admin"
  
  def index
    @grapes = Grape.all(:order => "name ASC").paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html
    end
  end
  
  def new
    @grape = Grape.new

    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @grape = Grape.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @grape = Grape.new(params[:grape])
    # @grape.image.destroy if @grape.image && !params[:grape][:image_file].blank?
    @grape.build_image(:image_file => params[:image]) unless params[:image].blank?
    
    if @grape.save
      redirect_to :action => :index
    else
      flash[:notice] = "There are something wrong"
      render :action => :new
    end
  end
  
  def update
    @grape = Grape.find(params[:id])
    
    if @grape.update_attributes(params[:grape])
      flash[:notice] = "Grape updated successfully"
    else
      flash[:notice] = "Grape is not updated successfully"
    end
    
    respond_to do |format|
      format.html { render :action => :edit }
    end
  end
  
  def destroy
    @grape = Grape.find(params[:id])

    if @grape.destroy
      flash[:notice] = "Grape is deleted!"
    end
    
    respond_to do |format|
      format.html { redirect_to :action => :index }
    end
  end
end
