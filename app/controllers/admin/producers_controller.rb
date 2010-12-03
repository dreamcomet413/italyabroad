class Admin::ProducersController < ApplicationController
  before_filter :admin_login_required
  layout "admin"
  
  def index
    @producers = Producer.all(:order => "id DESC").paginate(:page => params[:page], :per_page => 10)
    
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @producer = Producer.new
    
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @producer = Producer.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @producer = Producer.new(params[:producer])
    
    if @producer.save
      redirect_to :action => :index
    else
      flash[:notice] = "There are something wrong"
      render :action => :new
    end
  end
  
  def update
    @producer = Producer.find(params[:id])
    
    if @producer.update_attributes(params[:producer])
      flash[:notice] = "Producer updated successfully"
    else
      flash[:notice] = "Producer is not updated successfully"
    end
    
    respond_to do |format|
      format.html { render :action => :edit }
    end
  end
  
  def destroy
    @producer = Producer.find(params[:id])

    if @producer.destroy
      flash[:notice] = "Producer is deleted!"
    end
    
    respond_to do |format|
      format.html { redirect_to :action => :index }
    end
  end
end
