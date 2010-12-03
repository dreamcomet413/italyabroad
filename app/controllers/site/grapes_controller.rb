class Site::GrapesController < ApplicationController
  layout 'site'
  
  def index
    @grapes = Grape.all(:order => "name ASC")
    
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
