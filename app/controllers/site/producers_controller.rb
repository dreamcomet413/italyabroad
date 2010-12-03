class Site::ProducersController < ApplicationController
  layout 'site'
  
  def show
    @producer = Producer.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end
end
