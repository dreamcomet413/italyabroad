class Site::RegionsController < ApplicationController
  layout 'site'

  def index

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

