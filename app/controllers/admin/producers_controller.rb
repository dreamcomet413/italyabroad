class Admin::ProducersController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    if params[:search]
      @producers = Producer.find(:all,:conditions=>['name LIKE ? ',"%#{params[:search_text]}%"],:order => "id DESC").paginate(:page => params[:page], :per_page => 10)
    else
      @producers = Producer.all(:order => "id DESC").paginate(:page => params[:page], :per_page => 10)
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
       unless params[:image].nil?
    @image = Image.new(params[:image])
     @image.save
    @producer.image_id = @image.id
  end
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

