class Site::ProducersController < ApplicationController
  layout 'site'
    def index
    if params[:search]
      @producers = Producer.find(:all,:include=>'products',:conditions=>['producers.name LIKE ? AND products.active = ? AND products.quantity > ? AND producers.active = ? ',"%#{params[:search_by_name]}%",true,0,true],:order => "producers.name asc").paginate(:page => params[:page], :per_page => 10)
    else
      @producers = Producer.find(:all,:include=>'products',:conditions=>['products.active = ? and products.quantity > ? AND producers.active = ?',true,0,true],:order => "products.name asc").paginate(:page => params[:page], :per_page => 10)
    end
    @producers_all = Producer.find(:all,:conditions=>['active =?',true],:order => "name asc")
    respond_to do |format|
      format.html
    end
  end


  def show
    @producer = Producer.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
end

