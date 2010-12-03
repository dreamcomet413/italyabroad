class Admin::CustomersController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @users = User.regulars.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @user = User.regulars.new
  end

  def edit
    @user = User.regulars.find(params[:id])
  end

  def create
    @user = User.regulars.new(params[:user])

    if @user.save
      redirect_to :action => :index
    else
      flash[:notice] = @user.show_errors
      render :action => :new
    end
  end

  def update
    @user = User.regulars.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to :action => :index
    else
      flash[:notice] = @user.show_errors
      render :action => :edit
    end
  end

  def destroy
    User.regulars.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
