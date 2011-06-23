class Site::ProducersController < ApplicationController
  layout 'site'
    def index
    if params[:search]
      @producers = Producer.find(:all,:conditions=>['name LIKE ? ',"%#{params[:search_by_name]}%"],:order => "name asc").paginate(:page => params[:page], :per_page => 10)
    else
      @producers = Producer.all(:order => "name asc").paginate(:page => params[:page], :per_page => 10)
    end
    @producers_all = Producer.find(:all,:order => "name asc")
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

