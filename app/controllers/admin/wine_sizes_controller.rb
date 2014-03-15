class Admin::WineSizesController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @wine_sizes = WineSize.all
  end

  def new
    @wine_size = WineSize.new
  end

  def create
    @wine_size = WineSize.new(params[:wine_size])
    if @wine_size.save
      redirect_to admin_sommeliers_url, :notice => "Successfully created wine size."
    else
      render :action => 'new'
    end
  end

  def edit
    @wine_size = WineSize.find(params[:id])
  end

  def update
    @wine_size = WineSize.find(params[:id])
    if @wine_size.update_attributes(params[:wine_size])
      redirect_to admin_sommeliers_url, :notice  => "Successfully updated admin/wine size."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @wine_size = WineSize.find(params[:id])
    @wine_size.destroy
    redirect_to admin_sommeliers_url, :notice => "Successfully destroyed admin/wine size."
  end
end
