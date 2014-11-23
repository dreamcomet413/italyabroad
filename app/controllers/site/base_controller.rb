class Site::BaseController < ApplicationController
  layout "site"


  def index
    @setting = Setting.first
    #@best_sellers = Product.find(:all, :select => "id, rating", :order => "rating desc", :limit => 3)
    wine_categories = Category.find_by_sql("select * from categories where friendly_identifier LIKE 'white-wines'")
    @recommended_wines = Product.where("categories.id = ? AND products.raccomanded = ? AND product_prices.quantity > ?", wine_categories.last.try(:id), true, 0).includes([:categories, :product_prices]).order("products.created_at ASC").limit(4)

    food_categories = Category.find_by_sql("select * from categories where parent_id is null and name='Food'")
    @food_counter = Product.where("categories.id = ? AND products.raccomanded = ? AND product_prices.quantity > ?", food_categories.first.try(:id), true, 0).includes([:categories, :product_prices]).order("products.created_at ASC").limit(4)

    @best_sellers = Product.where("products.is_best_seller = ? AND product_prices.quantity > ?", true, 0).includes([:product_prices]).order("products.created_at ASC").limit(4) if Product.attribute_method?("is_best_seller")

    other_categories = Category.find_by_sql("select * from categories where friendly_identifier LIKE 'other-drinks'")
    @other_drinks = Product.where("categories.id = ? AND products.raccomanded = ? AND product_prices.quantity > ?", other_categories.last.try(:id), true, 0).includes([:categories, :product_prices]).order("products.created_at ASC").limit(4)

    @reviews = Review.where("").order("created_at DESC").limit(2)
  end

  def google_sitemap
    @products = Product.find(:all, :select => "friendly_identifier, name, updated_at", :conditions => ['active IS TRUE'])
    @posts = Post.find(:all, :select => "id, name, created_at")
    render :layout => false

    response_to do |format|
      format.xml
    end
  end

  def login
    # params[:user_type] = ""
    if request.post?
      # self.current_user = User.authenticate(params[:login], params[:password])
      logged_in = User.authenticate(params[:login], params[:password])
      if logged_in
        self.current_user = User.authenticate(params[:login], params[:password])
        current_user.set_last_seen_at
        session[:current_user] = current_user.id
        if current_user.admin?

          #   @setting.update_attribute('chat_available',true)
        end
        if current_user.omniauth?(params)
          current_user.authentications.create!(:provider => params[:provider], :uid => params[:uid], :token => params[:token])
        end

        redirect_to root_path
        #redirect_back_or_default(root_url)
      else
        flash[:notice] = "Wrong password or username " #+ "<br />"
        #flash[:notice] += "or <br />"
        #flash[:notice] += "The profile will be reviewed by a member of our team before being published"
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

          if simple_captcha_valid?
            @user.save(false)
            self.current_user = @user
            flash[:notice] = "Successfully logged in"
            redirect_back_or_default(root_url)
            # else part of captcha
          else
            flash[:guest_login] = " invalid captcha"
            render :action => "login"
          end
        else
          flash[:guest_login] = "Email is invalid"
          render :action => "login"
        end
      end
      #else part if there is no user
    else
      flash[:guest_login] = "Please provide Name and Email to login as guest."
      redirect_to :back
    end

  end

  def contact
    @contact_message = ContactMessage.last
    if request.post?
      @contact = Contact.new(params[:contact])
      #if @contact.valid_with_captcha?
      #   @contact.save_with_captcha
      if @contact.save
        flash[:title] = "Thank you"
        flash[:message] = "Your request has been submitted, we aim to respond within 48hr"
        Notifier.deliver_contact(@contact)
        @hide = true
      else
        flash[:title] = "Sorry"
        flash[:message] = "Your request couldn't be submitted because #{@contact.show_errors}".html_safe
      end

      redirect_to contact_us_path and return
    else
      @contact = Contact.new
    end
  end

  def logout
    self.current_user.forget_me if logged_in?
    if current_user.admin?
      @setting.update_attribute('chat_available',false)
    end
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
      # flash[:message] = @subscription.show_errors
      # flash[:message] = "Your request couldn't be submitted because<p>#{@subscription.show_errors}</p>"
      flash[:message] = "You are already subscribed to our newsletter"
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

  def guarantee_of_satisfaction
  end

end

