class Admin::CommentsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @comments = Comment.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end
  
  def destroy
    Comment.find(params[:id]).destroy
  end
end
