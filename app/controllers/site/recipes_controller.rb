class Site::RecipesController < ApplicationController
  layout "site"
  before_filter :store_location, :only => [:show]
  before_filter :chef_login_required, :only => :new 

  def index
    @show = true
  end

  def new
    @recipe = Recipe.new
  end
  def create

    if current_user == :false
      redirect_to login_url
    else
      if session[:current_user] == "guest"

        @recipe = Recipe.new(params[:recipe])
        @recipe.active = true

        @recipe.image_1.destroy if @recipe.image_1 && !params[:image_1].blank?
        @recipe.build_image_1(:image_filename => params[:image_1]) unless params[:image_1].blank?
        @recipe.user_id = 3
        if @recipe.save
          session[:current_user] = ''
          flash[:notice] = "<span style='color:green'>Recipe successfully created</span>"
          redirect_to :action => "index"
        else
          render :action => "new"
        end
      else

        @recipe = current_user.recipes.new(params[:recipe])
        @recipe.active = true
        @recipe.image_1.destroy if @recipe.image_1 && !params[:image_1].blank?
        @recipe.build_image_1(:image_filename => params[:image_1]) unless params[:image_1].blank?
        if @recipe.save
          flash[:alert] = "Recipe successfully created!"
          redirect_to :action => "index"
        else
          render :action => "new"
        end
      end
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    if @recipe
      @recipe.count_view
      @reviews = @recipe.reviews.where(['publish = ?',true]).
          paginate(:page => params[:page], :per_page => 5).offset(2).order('created_at DESC')
    else
      redirect_to '/404'
    end

  end

  def new_review
    @reviewer = Recipe.find(params[:id])
    @review = Review.new
    render :update do |page|
      if logged_in?
        page.replace_html("review_add", :partial => "site/shared/review_add")
      else
        page << "alert('You need to login for submit a review')"
      end
    end
  end

  def create_review
    @review = Recipe.find(params[:id]).reviews.build(params[:review])
    @review.user_id = current_user.id
    if @review.save
      status = "Review correctly published!"
    else
      status = "Your body message is empty."
    end
    @reviewer = @review.reviewer
    render :update do |page|
      page << "alert('#{status}')"
      page.replace_html("review_view", :partial => "site/shared/review_view_short")
      page.replace_html("review_add", "")
    end
  end

  def send_to_friend
    @recipe = Recipe.find(params[:id])
    if params[:email] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      Notifier.send_to_friend(params[:email], url_for(:host => "www.italyabroad.com",
          :controller => "site/recipes",
          :action => :show,
          :id => @recipe)).deliver

      status = "E-mail correctly send"
    else
      status = "Wrong e-mail."
    end

    render :update do |page|
      page << "alert('#{status}')"
    end
  end

  def print
    @recipe = Recipe.find(params[:id])
    if logged_in?
      make_and_send_pdf("/recipes/print", "Italyabroad_Recipe_#{@recipe.id}.pdf")
    else
      session[:return_to] = url_for :action => :show, :id => @recipe
      redirect_to :controller => :base, :action => 'login'
    end
  end

  def recipes_list
    @recipes = Recipe.find(:all,:conditions=>['user_id = ?',params[:user_id]])
    @user = User.find_by_id(params[:user_id])
  end

end

