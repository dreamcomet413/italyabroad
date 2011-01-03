class Site::ReviewsController < ApplicationController
  before_filter :site_login_required,:except=>[:show]

  def index
    @reviews = current_user.reviews.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { render :layout => 'site' }
    end
  end

  def create
    @review = reviewer.reviews.new(params[:review])
    @review.user = current_user

    if @review.save
      status = "Review correctly published!"
    else
      status = "Your body message is empty."
    end
    redirect_to(params[:return_to])
  end

  def show
    @review = Review.find(params[:id])
    render :layout=>'site'
  end

  private

  def reviewer
    return Product.find(params[:product_id]) if !params[:product_id].blank?
    return Recipe.find(params[:recipe_id]) if !params[:recipe_id].blank?
  end
end

