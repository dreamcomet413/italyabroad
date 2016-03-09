class Admin::CustomersController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    if params[:search] and !params[:field_text].blank?
    @users = User.paginate(:conditions=>"(#{params[:field_text]} LIKE '%#{params[:search_text]}%') AND type_id like '%#{params[:user_type]}%'",:page => params[:page], :per_page => 20).order('id desc')
    elsif params[:search] and params[:field_text].blank?
    @users = User.paginate(:conditions=>"(name LIKE '%#{params[:search_text]}%' OR login LIKE '%#{params[:search_text]}%' OR surname LIKE '%#{params[:search_text]}%')AND type_id like '%#{params[:user_type]}%'",:page => params[:page], :per_page => 20).order('id desc')
    elsif params[:search] and !params[:user_type].blank?
       @users = User.paginate(:conditions=>['type_id like ?',"%#{params[:user_type]}%"],:page => params[:page], :per_page => 20).order('id desc')
     else
      @users = User.regulars.paginate(:page => params[:page], :per_page => 20).order('id desc')
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
    from_cart = false
    if(params[:return_to])
      from_cart = true
      u = nil
      # if from cart then try to find user by login or email ad update existing user.
      if !params[:user][:login].empty?
        u = User.find_by_login(params[:user][:login])
      end
      if u.nil? and !params[:user][:email].empty? 
        u = User.find_by_email(params[:user][:email])
      end
      if u 
        # u.update_attributes params[:user]
        @user=u 
      end
    end
    
    # dont validate if admin ordering as customer from cart
    if @user.save(:validate=>!from_cart)
      # save admin to restore later and redirect to cart after loging in the new user
      if from_cart
        switch_session
        redirect_to '/site/cart/gift_options'
      else
        redirect_to :action => :index
      end
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

  def print_user_details
     if params[:search] and !params[:field_text].blank?
    @users = User.find(:all,:conditions=>"(#{params[:field_text]} LIKE '%#{params[:search_text]}%') AND type_id = '#{params[:user_type]}'",:order=>'dob asc')
    elsif params[:search] and params[:field_text].blank?
    @users = User.find(:all,:conditions=>"(name LIKE '%#{params[:search_text]}%' OR login LIKE '%#{params[:search_text]}%' OR surname LIKE '%#{params[:search_text]}%')AND type_id = '#{params[:user_type]}'",:order=>'dob asc')
    elsif params[:search] and !params[:user_type].blank?
       @users = User.find(:all,:conditions=>['type_id =?',"#{params[:user_type]}"],:order=>'dob asc')
     else
      @users = User.find(:all,:conditions => ['type_id = ? or type_id = ? or type_id = ?', 2,4,3],:order=>'dob asc')
    end
    render :layout => "print"
  end
end

