class Site::BaseController < ApplicationController
  layout "site"

  def index
    @setting = Setting.first
  end

  def google_sitemap
    @products = Product.find(:all, :select => "friendly_identifier, name, updated_at", :conditions => ['active IS TRUE'])
    @posts = Post.find(:all, :select => "id, name, created_at")
    render :layout => false
  end

  def login
  # params[:user_type] = ""
    if request.post?
    # self.current_user = User.authenticate(params[:login], params[:password])
    logged_in  = User.authenticate(params[:login], params[:password])
      if logged_in
        self.current_user = User.authenticate(params[:login], params[:password])
        current_user.set_last_seen_at
        redirect_back_or_default(root_url)
      else
        flash[:notice] = "Wrong password or username"
        redirect_to :back
      end
    end
  end

  def guest_login
    params[:user_type] = "Guest"

    reg = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    if (!params[:name].blank? && !params[:email].blank?)
      @user = User.find_by_name_and_email(params[:name],params[:email])
      #@user = User.find(:first,:include=>[:type],:conditions=>["users.name = ? and users.email = ? and types.name != ? ",params[:name],params[:email],params[:user_type]])

      if @user
        if @user.type_id == 3
          self.current_user = @user
          flash[:notice] = "Successfully logged in"
          redirect_back_or_default(root_url)
        else
          flash[:notice] = "You are already registered, please login to continue."
          redirect_to :back
        end
      else
        if !(reg.match(params[:email])).nil?
          @user= User.new(:name => params[:name], :email => params[:email], :type_id => 3, :photo_default=>"default",  :login => params[:email] )
            @user.save(false)
            self.current_user = @user
            flash[:notice] = "Successfully logged in"
            redirect_back_or_default(root_url)
        else
        flash[:guest_login] = "Email is invalid"
        render :action => "login"
        end
      end
    else
      flash[:guest_login] = "Please provide Name and Email to login as guest."
      redirect_to :back
    end
  end

  def contact
    if request.post?
      @contact = Contact.new(params[:contact])
      if @contact.save_with_captcha
        #        @contact.save_with_captcha
        flash[:title] = "Thank you"
        flash[:message] = "Your request has been submitted, we aim to respond within 48hr"
        Notifier.deliver_contact(@contact)
        @hide = true
      else
        flash[:title] = "Sorry"
        flash[:message] = "Your request couldn't be submitted because<p>#{@contact.show_errors}</p>"
      end

      redirect_to contact_us_path and return
    else
      @contact = Contact.new
    end
  end

  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_back_or_default(root_url)
  end

  def subscribe
    @subscription = Subscription.new(params[:subscription])
  end

  def create_subscription
    @subscription = Subscription.new(params[:subscription])
    if @subscription.save
      redirect_to subscription_complete_path
    else
      flash[:title] = "Sorry"
     # flash[:message] = "Your subscription couldn't be submitted because already subscribed using this email"
     flash[:message] = @subscription.show_errors
      render :action => :subscribe
    end
  end

  def subscription_complete
  end

  def unsubscribe
    if request.post? && params[:subscriptions]
      if subscription = Subscription.find_by_email(params[:subscriptions][:email])
        subscription.destroy
        @hide = true
        flash[:title] = "Unsubscribe"
        flash[:message] = "Your details have been removed."
      else
        @hide = false
        flash[:title] = "Sorry"
        flash[:message] = "We don't have any record of your details."
      end
    end
  end

  def terms_conditions
    render :layout => false
  end

  def supplier

  end
  def wine_club

  end
end

