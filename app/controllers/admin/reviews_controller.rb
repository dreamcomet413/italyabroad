class Admin::ReviewsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @reviews = Review.where("").order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    if params[:approve]
      for review in params[:publish]
        @review = Review.find(review)
        @review.update_attribute('publish',true)
        @review = Review.find_by_reviewer_id_and_reviewer_type(@review.reviewer_id,'Product',:order=>'id asc',:limit=>1)
        unless @review.blank?
          if @review.cupon_send == false

            cupon_code = ""
            #(8+rand(10)).times{coupon_code << (65 + rand(25)).chr}
            cupon_code = ((1..9).to_a + ('a'..'z').to_a + ('A'..'Z').to_a).shuffle.join[1..10]
            #coupon_code << rand(1000).to_s
            Cupon.create(:code=>cupon_code,:price=>10,:min_order=>80,:active=>1,:cupon_type=>'price')
            Notifier.coupon_notification_for_first_review(Product.find(@review.reviewer_id),@review.user,cupon_code).deliver unless @review.user.blank?
            @review.update_attribute('cupon_send',true)
          end
        end
      end

    end

    respond_to do |format|
      format.html
    end
  end

  def send_mails
    reviews = []
    params[:ids].split(",").collect{|x| reviews << Review.find(x)}
    recipients = reviews.collect{|u| u.user_id}.uniq!
    #if recipients.size > 1
      recipients.each do |recipient|
        #reviews = reviews.find(:user_id => recipient)
        reviews = reviews.collect{|r| r if r.user_id == recipient}.compact
        Notifier.review_invitation(reviews, User.find(recipient)).deliver
      end
    #end
    respond_to do |format|
      format.html do
        flash[:notice] = "Review Request Invitation successfully sent"
        redirect_to admin_reviews_path
      end
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

