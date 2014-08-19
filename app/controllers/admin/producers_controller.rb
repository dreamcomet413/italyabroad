class Admin::ProducersController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    if params[:search]
      @producers = Producer.where(['name LIKE ? ',"%#{params[:search_text]}%"]).order("id DESC").paginate(:page => params[:page], :per_page => 10)
    else
      @producers = Producer.where("").order("id DESC").paginate(:page => params[:page], :per_page => 10)
    end
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
    @producer.build_image(:image_filename => params[:image]) unless params[:image].blank?
    unless params[:image].nil?
      @image = Image.new(params[:image])
      @image.save
      @producer.image_id = @image.id
     end
    if @producer.save
      redirect_to :action => :index
    else
      flash[:notice] = "There are something wrong"
      render :action => :new
    end
  end

  def update
    @producer = Producer.find(params[:id])
    @producer.image.destroy if @producer.image && !params[:image].blank?
    @producer.build_image(:image_filename => params[:image]) unless params[:image].blank?

    respond_to do |format|
      if @producer.update_attributes(params[:producer])
        format.html { render action: "edit" }
        flash[:notice] = "Producer updated successfully"
      else
        format.html { render action: "edit" }
        flash[:notice] = "Producer is not updated successfully"
      end
    end
  end

  def destroy
      @producer = Producer.find(params[:id])

      if !@producer.products.present?
        if @producer.destroy
          flash[:notice] = "Producer is deleted!"
        end
      else
        flash[:notice] = "We have products from this producer displayed in the site, So this producer cannot be deleted!"
      end

      respond_to do |format|
      format.html { redirect_to :action => :index }
    end
  end
end

