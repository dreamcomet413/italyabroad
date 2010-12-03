class Admin::ForumsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @forums = Forum.all(:order => "name ASC").paginate(:page => params[:page], :per_page => 10)
    
    respond_to do |format|
      format.html
    end
  end
  
end
