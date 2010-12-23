class Site::MessagesController < ApplicationController
   before_filter :site_login_required
  def index
     @messages = Message.find(:all,:conditions=>['user_id =?',params[:id]],:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
      respond_to do |format|
      format.html { render :layout => 'site' }
    end
  end
end

