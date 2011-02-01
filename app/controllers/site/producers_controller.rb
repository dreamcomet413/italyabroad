class Site::ProducersController < ApplicationController
  layout 'site'
    def index
    @producers = Producer.find(:all,:order=>'name asc').paginate(:page => params[:page], :per_page => 10)
    @producers_all = Producer.find(:all,:order=>'name asc')

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

