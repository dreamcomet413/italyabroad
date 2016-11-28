class Site::GrapesController < ApplicationController
  layout 'site'


  def index
    if params[:search]
      @grapes = Grape.where(['name LIKE ? ',"%#{params[:search_by_name]}%"]).order("name asc").paginate(:page => params[:page], :per_page => 10)
    else
      @grapes = Grape.where("id is not null").order('name asc').paginate(:page => params[:page], :per_page => 10)
    end
    @grapes_all = Grape.find(:all,:order=>'name asc')
    respond_to do |format|
      format.html
    end
  end


  def search_results
    if params[:search]
      @grapes = Grape.where(['name LIKE ? ',"%#{params[:search_by_name]}%"]).order("name asc").paginate(:page => params[:page], :per_page => 10)
    else
      @grapes = Grape.where("id is not null").order('name asc').paginate(:page => params[:page], :per_page => 10)
    end
    @grapes_all = Grape.find(:all,:order=>'name asc')
    respond_to do |format|
      format.html
    end
  end

  def show
    @grape = Grape.find(params[:id])
    
    if @grape.nil?
      redirect_to '/404'
      flash[:notice]="Sorry the grape you are looking for cannot be found"
      return
    end

    respond_to do |format|
      format.html
    end
  end
end

