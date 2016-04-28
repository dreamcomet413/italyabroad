class Site::ReviewsController < ApplicationController
  before_filter :site_login_required,:except=>[:show]

  def index
    @reviews = current_user.reviews.all(:conditions=>['publish =?',true],:limit=>10,:order => "created_at DESC")
    @followers = Follower.find(:all,:conditions=>['follower_id = ?',current_user.id])
   # .paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html { render :layout => 'site' }
    end
  end

  def create
    @review = reviewer.reviews.new(params[:review])
    @review.user = current_user

    if @review.save
      if @review.reviewer_type.upcase == 'PRODUCT'
      Notifier.deliver_new_review_added(Product.find(@review.reviewer_id),current_user,AppConfig.admin_email,@review)
    elsif @review.reviewer_type.upcase == 'RECIPE'
      Notifier.deliver_new_review_added(Recipe.find(@review.reviewer_id),current_user,AppConfig.admin_email,@review)
      end
      flash[:notice] = 'Review correctly published!'
      status = "Review correctly published!"
    else
      status = "Your body message is empty."
    end
      redirect_to params[:return_to]
    end

  def show
    @review = Review.find(params[:id])
    @product = Product.find(params[:product_id]) if !params[:product_id].blank?
    render :layout=>'site'
  end

  private

  def reviewer
    return Product.find(params[:product_id]) if !params[:product_id].blank?
    return Recipe.find(params[:recipe_id]) if !params[:recipe_id].blank?
  end
end

