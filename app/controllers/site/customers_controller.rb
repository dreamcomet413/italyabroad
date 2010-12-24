class Site::CustomersController < ApplicationController
  before_filter :site_login_required, :except => [:new, :create, :confirmation, :find, :request_new_password, :show,:update_default_pic]

  layout "site"

  ssl_required :new, :create, :account, :order if RAILS_ENV == "production"

  def new
    @user = User.new
  end

  def show
    store_location
    @user = User.find(params[:id])
    @my_profile = @user == current_user
    respond_to do |format|
      format.html
    end
  end

  def print_invoice
    @order = Order.find(params[:id])
    if @order.user != current_user
      redirect_to :controller => :base, :action => :index
    else
      make_and_send_pdf("site/customers/print_invoice", "Italyabroad_Invoice_#{@order.id}.pdf")
    end
  end

  def print_tasting
    @order = Order.find(params[:id])
    if @order.user != current_user
      redirect_to :controller => :base, :action => :index
    else
      @tasting_notes = true
      make_and_send_pdf("site/customers/print_tasting", "Italyabroad_Tasting_Notes_#{@order.id}.pdf")
    end
  end

  def create
    @user = User.new(params[:user])
    unless params[:photo].nil?
    @photo = Photo.new(params[:photo])
     @photo.save
    @user.photo_id = @photo.id
  else
    set_photo_from_default(params[:kind],@user)
  end
    if params[:chef].to_i == 4
      @user.type_id = 4
      @user.active = false
   else
       @user.type_id = 2
      @user.active = true
  end
    #@user.activation_code = ActivePassword.new #Customers don't wont activations
    if @user.save
      flash[:title] = "Congratulations"
      flash[:message] = "Your account has been created, an email with your account details has been sent to #{@user.email}."
      if @user.type_id != 4
      self.current_user = User.authenticate(@user.login, @user.password_clean)
#      redirect_back_or_default(:action => :messages)
      end
      redirect_back_or_default(root_url)
    else
      flash[:notice] = @user.show_errors
      render :action => :new
    end
  end

  def confirmation
    @user = User.find_by_id(params[:id])

    if @user
      if @user.activation_code == params[:code]
        if @user.active
          flash[:title] = "Congratulations"
          flash[:message] = "Your account has been activated"
        else
          if @user.update_attributes({:active => true})
            Notifier.deliver_account_created(@user)
            self.current_user = User.authenticate(@user.login, @user.password_clean)
            flash[:title] = "Congratulations"
            flash[:message] = "Your account has been created, an email with your account details has been sent to #{@user.email}."
          else
            flash[:title] = "Sorry"
            flash[:message] = "We are experiencing some problems, please try again later or contact us."
          end
        end
      else
        flash[:title] = "Sorry"
        flash[:message] = "Your details are incorrect, please try again or contact us."
      end
    else
      flash[:title] = "Sorry"
      flash[:message] = "We couldn't find your account, please contact us or create a new account."
    end

    render :action => :messages
  end

  def account
    @user = current_user
    unless @user.photo_id.nil? or @user.photo_id.blank?
     @photo = Photo.find_by_id(current_user.photo_id)
    end

    redirect_to :controller => :base, :action => :index if @user.nil?

  end

  def update_default_pic
  #  @user = current_user
  # set_photo_from_default(params[:kind],@user)

  render :layout => false
  end

  def update
     @user = current_user
    old_mail = @user.email
     unless params[:photo].nil?
    @photo = Photo.new(params[:photo])
     @photo.save
    @user.photo_id = @photo.id
  else
    set_photo_from_default(params[:kind],@user)
  end
   # @user.set_photo_from_upload(params[:photo])
    if @user.update_attributes(params[:user])
        Notifier.deliver_account_data(User.find(@user.id))
        flash[:title] = "Congratulations"
        flash[:message] = "Your account has been update, you will now receive an email"
   #   render :action => :messages
   redirect_to root_url
    else
      flash[:notice] = @user.show_errors
      render :action => :account
    end
  end

  def find
    @user = User.find_by_login(params[:user][:login])
    @user = User.find_by_email(params[:user][:email]) if @user.nil?
    if @user
      Notifier.deliver_account_data(@user)
      flash[:title] = "Mail Sent"
      flash[:notice] = "Your login details have been sent to #{@user.email}."
    else
      flash[:title] = "Sorry"
      flash[:notice] = "Sorry We couldn't find your account, please contact us or create a new account"
    end
    redirect_to root_url
  end

  def follow
    follower = User.find(params[:user_id])
    follower.followers.create(:follower_id => current_user.id) if follower && !follower.followed_by?(current_user)

    respond_to do |format|
      if follower
        format.html { redirect_to(customer_path(follower)) }
      else
        format.html { redirect_to(customer_path(current_user)) }
      end
    end
  end

  def send_message
    @message = Message.new(:name=>params[:name],:user_id=>params[:user_id],:send_by_id=>params[:send_by])
    if @message.save
      redirect_to customer_path(params[:user_id])
    else
      flash[:notice] = @message.show_errors
      redirect_to customer_path(params[:user_id])
    end
  end

  def unfollow
    user = User.find(params[:user_id])
    follower = user.followers.find_by_follower_id(current_user.id)

    respond_to do |format|
      if user && follower
        follower_id = follower.follower_id
        follower.destroy
        format.html { redirect_to(customer_path(user)) }
      else
        format.html { redirect_to(customer_path(current_user)) }
      end
    end
  end

 def request_new_password

    respond_to do |format|
      format.html
    end
  end

  def set_photo_from_default(kind,user)
    case kind
    when "1"
      image = AppConfig.avatar_1
    when "a"
      image = AppConfig.avatar_2
    when "b"
      image = AppConfig.avatar_3
    when "c"
      image = AppConfig.avatar_4
    when "d"
      image = AppConfig.avatar_5
    when "e"
      image = AppConfig.avatar_6
    end


    if image
    user.photo_id = ""
    user.photo_default = image
   # @photo = Photo.new
   # @photo.image_file = image
    # user.photo = image
   # @photo.save
   # user.photo_id = @photo.id

      begin
    #  user.photo.destroy if user.photo
      rescue => e
        logger.info "Unexpected error when delete photo #{self.photo.id} \n #{e.inspect}"
      end
     # user.photo_id = nil
    #  user.save
    end

  end

end

