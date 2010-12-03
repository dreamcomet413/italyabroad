class Site::BlogController < ApplicationController
  layout "site"
  before_filter :store_comment, :only => :comment, :method => :post
#  before_filter :site_login_required, :only => :comment
  def index
    per_page = params[:show].to_s == "all" ? 9999999 : 4
    if params[:year].blank? && params[:month].blank?
      @posts = Post.find(:all, :conditions => ["blog_type_id = ?", 1], :order  => "created_at DESC").paginate(:page => params[:page], :per_page => per_page)
    else
      year = params[:year].to_i
      month = params[:month].to_i
      begin_of_the_month = "1/#{month}/#{year}".to_time.utc
      end_of_the_month = begin_of_the_month.end_of_month.to_time.utc
      @posts = Post.find(:all, :conditions => ["blog_type_id = ? AND created_at >= ? AND created_at <= ?", 1, begin_of_the_month.to_s(:db), end_of_the_month.to_s(:db)])
    end

    respond_to do |wants|
      wants.html
      wants.xml { render :layout => false }
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @post.count_view if @post
    @comments = (@post.comments.latest).paginate(:page => params[:page], :per_page => 5, :offset => 5,:order => "created_at DESC")
  end
  
  def comment
    @post = Post.find(params[:id])
    @comment = Comment.new(
      :name => session[:name],
      :description => session[:description],
      :captcha => session[:captcha],
      :captcha_key => session[:captcha_key],
      :mail_check => session[:mail_check]
    )
    @comment.post = @post
    @comment.email = current_user.email
    @comment.user_id = current_user.id
    if @comment.save_with_captcha
      check_mail_list(@post, current_user)
      flash[:notice] = "comment is successfully posted"
      redirect_to blog_path(:id => @post.id)
    else
      flash[:notice] = @comment.show_errors
      render :action => :show
    end
  end

  protected
  def store_comment
    
    if params[:comment]
      session[:name] = params[:comment][:name]
      session[:description] = params[:comment][:description]
      session[:captcha] = params[:comment][:captcha]
      session[:captcha_key] = params[:comment][:captcha_key]
      session[:mail_check] = params[:comment][:mail_check]
    end
  end
  
  def check_mail_list(post, user)
    @post = Post.find(post)
    no_of_comment = @post.comments.count
    if no_of_comment == 1
      return true
    else
      p no_of_comment
      @comments = (@post.comments).find(:all, :conditions =>{:mail_check => 1})
      p "********tyty***************************"
      p @comments.count
      p "**********ytyy**************************"
      for comment in @comments
        Notifier.deliver_comment(comment,user)
      end
    end
  end
  
end
