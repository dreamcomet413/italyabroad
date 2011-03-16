class Admin::ReviewsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index

    @reviews = Review.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
    if params[:approve]
      for review in params[:publish]
        @review = Review.find(review)
        @review.update_attribute('publish',true)
      end
    end

    respond_to do |format|
      format.html
    end
  end

  def new
    @review = Review.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @review = Review.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def create
    @review = Review.new(params[:review])
    @review.user = current_user
    if @review.save
      redirect_to admin_reviews_path
    else
      flash[:notice] = @review.show_errors
      render :action => :new
    end
  end

  def update
    @review = Review.find(params[:id])

    if @review.update_attributes(params[:review])
      redirect_to :action => :index
    else
      flash[:notice] = @review.show_errors
      render :action => :edit
    end
  end

  def destroy
    Review.find(params[:id]).destroy
    redirect_to :action => :index
  end
end

