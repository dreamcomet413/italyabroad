class Admin::RegionsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @regions = Region.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html
    end
  end

  def new
    @region = Region.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @region = Region.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def create
    @region = Region.new(params[:region])
  unless params[:image].nil? and !@region.valid?
    @image = Image.new(params[:image])
     @image.save
    @region.image_id = @image.id
  end


    if @region.save
      flash[:notice] = "Region is created successfully"
      redirect_to :action => :index
    else
      flash[:notice] = "There something wrong"
      render :action => :new
    end
  end

  def update
    @region = Region.find(params[:id])
    unless params[:image].nil?
    @image = Image.new(params[:image])
     @image.save
    @region.image_id = @image.id
  end

    if @region.update_attributes(params[:region])
      flash[:notice] = "Region is updated successfully"
    else
      flash[:notice] = "There are something wrong"
    end

    render :action => :edit
  end

  def destroy
    @region = Region.find(params[:id])

    if @region.destroy
      flash[:notice] = "Region is deleted successfully"
    else
      flash[:notice] = "There is something wrong"
    end

    redirect_to :action => :index
  end
end

