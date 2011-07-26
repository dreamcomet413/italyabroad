class Admin::FaqsController < ApplicationController
  layout "admin"
  before_filter :admin_login_required

  def index
    @faqs = Faq.find(:all,:conditions=>search_conditions,:order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
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
      redirect_to admin_faqs_path
    else
      flash[:notice] = @faq.show_errors
      render :action => :new
    end
  end

  def edit
    @faq = Faq.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def update
    @faq = Faq.find(params[:id])
      if @faq.update_attributes(params[:faq])
        flash[:notice] = "Faq updated successfully"
        unless params[:faq][:answer].blank?
          Notifier.deliver_faq_answered_notification(@faq)
        end
        redirect_to admin_faqs_path
      else
         render :action => "edit"
      end
  end

  def destroy
    Faq.find_by_id(params[:id]).destroy
    redirect_to :action => :index
  end

  private

  def search_conditions
    conditions = []
    conditions << "publish = true " if params[:publish] and params[:publish].to_i == 1.to_i
    conditions << "publish = false " if params[:publish] and params[:publish].to_i == 0.to_i
    conditions << "answer = ''" if params[:answered] and params[:answered].to_i == 0.to_i
    conditions << "answer != ''" if params[:answered] and params[:answered].to_i == 1.to_i
    conditions << "question LIKE '%#{params[:question]}%'"
    conditions = conditions.join(" AND ")
    conditions = nil if conditions.blank?
    return conditions
  end
end

