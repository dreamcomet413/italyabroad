class Admin::GrapesController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    if params[:search]
       @grapes = Grape.where(['name LIKE ? ',"%#{params[:search_text]}%"]).order("name ASC").paginate(:page => params[:page], :per_page => 10)
    else
        @grapes = Grape.where("").order("name ASC").paginate(:page => params[:page], :per_page => 10)
    end

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
    @grape.build_image(:image_filename => params[:image]) unless params[:image].blank?
    unless params[:image].nil?
      @image = Image.new(params[:image])
      @image.save
      @grape.image_id = @image.id
    end

    if @grape.save
      redirect_to :action => :index
    else
      flash[:notice] = "There are something wrong"
      render :action => :new
    end
  end

  def update
    @grape = Grape.find(params[:id])

    @grape.image.destroy if @grape.image && !params[:image].blank?
    @grape.build_image(:image_filename => params[:image]) unless params[:image].blank?

    respond_to do |format|
      if @grape.update_attributes(params[:grape])
        format.html { render action: "edit" }
        flash[:notice] = "Grape updated successfully"
      else
        format.html { render action: "edit" }
        flash[:notice] = "Grape is not updated successfully"
      end
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

