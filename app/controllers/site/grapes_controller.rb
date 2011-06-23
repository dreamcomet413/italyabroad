class Site::GrapesController < ApplicationController
  layout 'site'


  def index
    if params[:search]
      @grapes = Grape.find(:all,:conditions=>['name LIKE ? ',"%#{params[:search_by_name]}%"],:order => "name asc").paginate(:page => params[:page], :per_page => 10)
    else
      @grapes = Grape.find(:all,:order=>'name asc').paginate(:page => params[:page], :per_page => 10)
    end
    @grapes_all = Grape.find(:all,:order=>'name asc')
    respond_to do |format|
      format.html
    end
  end

  def show
    @grape = Grape.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
end

