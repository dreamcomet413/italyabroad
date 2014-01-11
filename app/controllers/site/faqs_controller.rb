class Site::FaqsController < ApplicationController
  layout "site"
  before_filter :site_login_required,:except=>[:index]

  def index
    store_location
    @faqs = Faq.where(['publish = true AND  answer != ""']).order("created_at DESC").paginate(:page => params[:page], :per_page => 3)
  end


  def new
    @faq = Faq.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @faq = Faq.new(params[:faq])

    if @faq.save
      #flash[:notice] = 'Thank you for your interest in Italyabroad.com. <br/>'
      #flash[:notice] += 'Expect the answer soon.'
      flash[:notice] = 'Thank you for question, we will answer you as soon as possible'
      Notifier.deliver_faq_notification(@faq,current_user)
      redirect_to faqs_path
    else
      flash[:notice] = @faq.show_errors
      render :action => 'index'
    end
  end


end

