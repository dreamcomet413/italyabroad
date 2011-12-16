class Admin::CommentsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @comments = Comment.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to :action => :index
  end

  def approve_comment
    if params[:id] and request.xhr?
       @comment = Comment.find(params[:id])
       @comment.update_attribute('public',true)
       render :update do |page|
         page.alert("Approved successully")
          page.reload()
       end
     end

  end
end

