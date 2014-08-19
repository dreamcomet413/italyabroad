class Admin::RegionsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    if params[:search]
      @regions = Region.where(['name LIKE ? ',"%#{params[:search_text]}%"]).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    else
      @regions = Region.where("").order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    end
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
    @region.build_image(:image_filename => params[:image]) unless params[:image].blank?
    unless params[:image].nil?
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
    @region.image.destroy if @region.image && !params[:image].blank?
    @region.build_image(:image_filename => params[:image]) unless params[:image].blank?

    respond_to do |format|
      if @region.update_attributes(params[:region])
        format.html { render action: "edit" }
        flash[:notice] = "Region updated successfully"
      else
        format.html { render action: "edit" }
        flash[:notice] = "Region is not updated successfully"
      end
    end
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

