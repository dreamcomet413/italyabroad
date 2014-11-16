class Admin::SubscriptionsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @subscriptions = Subscription.where("").paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html
    end
  end
  
  def new
    @subscription = Subscription.n  ew
    
    respond_to do |format|
      format.html
    end
  end

  def edit
    @subscription = Subscription.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  def create
    @subscription = Subscription.new(params[:subscription])

    if @subscription.save
      flash[:notice] = "Subscriber is created successfully"
      redirect_to :action => :index
    else
      flash[:notice] = @subscription.show_errors
      render :action => :new
    end
  end

  def update
    @subscription = Subscription.find(params[:id])

    if @subscription.update_attributes(params[:subscription])
      flash[:notice] = "Subscriber is updated successfully"
    else
      flash[:notice] = @subscription.show_errors
    end
    
    respond_to do |format|
      format.html { render :action => :edit }
    end
  end

  def destroy
    Subscription.find(params[:id]).destroy
    
    respond_to do |format|
      format.html { redirect_to :action => :index }
    end
  end
end
