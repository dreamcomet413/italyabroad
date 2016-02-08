class Site::ProducersController < ApplicationController
  layout 'site'
  def index
    if params[:search]
      @producers = Producer.where(['producers.name LIKE ? AND products.active = ? AND products.quantity > ? AND producers.active = ? ',"%#{params[:search_by_name]}%",true,0,true]).
          includes("products").paginate(:page => params[:page], :per_page => 10)
    else
      @producers = Producer.where(['products.active = ? and products.quantity > ? AND producers.active = ?',true,0,true]).
          includes("products").order("products.name asc").paginate(:page => params[:page], :per_page => 10)
    end
    @producers_all = Producer.find(:all,:conditions=>['active =?',true],:order => "name asc")
    respond_to do |format|
      format.html
    end
  end


  def show
    @producer = Producer.find(params[:id])

    if @producer.nil? 
      redirect_to site_producers_path
      return
    end

    respond_to do |format|
      format.html
    end
  end
end

