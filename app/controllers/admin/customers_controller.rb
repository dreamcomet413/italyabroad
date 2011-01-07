class Admin::CustomersController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    if params[:search] and !params[:field_text].blank?
    @users = User.paginate(:conditions=>"(#{params[:field_text]} LIKE '%#{params[:search_text]}%') AND type_id = '#{params[:user_type]}'",:page => params[:page], :per_page => 10,:order=>'id desc')
    elsif params[:search] and params[:field_text].blank?
    @users = User.paginate(:conditions=>"(name LIKE '%#{params[:search_text]}%' OR login LIKE '%#{params[:search_text]}%' OR surname LIKE '%#{params[:search_text]}%')AND type_id = '#{params[:user_type]}'",:page => params[:page], :per_page => 10,:order=>'id desc')
    elsif params[:search] and !params[:user_type].blank?
       @users = User.paginate(:conditions=>['type_id =?',"#{params[:user_type]}"],:page => params[:page], :per_page => 10,:order=>'id desc')
     else
      @users = User.regulars.paginate(:page => params[:page], :per_page => 10,:order=>'id desc')
    end
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

