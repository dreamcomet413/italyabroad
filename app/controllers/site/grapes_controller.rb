class Site::GrapesController < ApplicationController
  layout 'site'
  
  def index
    @grapes = Grape.find(:all,:order=>'name asc').paginate(:page => params[:page], :per_page => 10)

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