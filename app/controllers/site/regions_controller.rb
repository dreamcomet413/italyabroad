class Site::RegionsController < ApplicationController
  layout 'site'

  def index
    if params[:search]
      @regions = Region.where(['name LIKE ? AND active = ? ',"%#{params[:search_by_name]}%",true]).order("name asc").
          paginate(:page => params[:page], :per_page => 10)
    else
      @regions = Region.where(['active = ?',true]).order("name asc").paginate(:page => params[:page], :per_page => 10)
    end
    @regions_all = Region.find(:all,:conditions=>['active = ?',true],:order => "name asc")
    respond_to do |format|
      format.html
    end
  end

  def show
    @region = Region.find(params[:id])

    if @region.nil?
      redirect_to regions_path
      return
    end
    
    respond_to do |format|
      format.html
    end
  end
end

