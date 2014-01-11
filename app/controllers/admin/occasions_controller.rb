class Admin::OccasionsController < ApplicationController
  layout "admin"
  before_filter :admin_login_required

  def index
    @occasions = Occasion.find(:all)
  end
 def new
    @occasion = Occasion.new

    respond_to do |format|
      format.html
    end
  end
def edit
    @occasion = Occasion.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
   def destroy
    Occasion.find_by_id(params[:id]).destroy
    redirect_to :action => :index
  end
   def create
    @occasion = Occasion.new(params[:occasion])

    if @occasion.save
      redirect_to admin_occasions_path
    else
      flash[:notice] = @occasion.show_errors
      render :action => :new
    end
  end

  def update
    @occasion = Occasion.find(params[:id])
      if @occasion.update_attributes(params[:occasion])
        flash[:notice] = "Occasion updated successfully"
        redirect_to admin_occasions_path
      else
         render :action => "edit"
      end
  end

end

