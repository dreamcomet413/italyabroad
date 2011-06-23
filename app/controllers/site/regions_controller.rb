class Site::RegionsController < ApplicationController
  layout 'site'

  def index

     if params[:search]
      @regions = Region.find(:all,:conditions=>['name LIKE ? ',"%#{params[:search_by_name]}%"],:order => "name asc").paginate(:page => params[:page], :per_page => 10)
    else
      @regions = Region.find(:all,:order => "name asc").paginate(:page => params[:page], :per_page => 10)
    end
    @regions_all = Region.find(:all,:order => "name asc")
    respond_to do |format|
      format.html
    end
  end

  def show
    @region = Region.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
end

