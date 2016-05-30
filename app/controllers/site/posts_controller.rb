class Site::PostsController < ApplicationController
  layout 'site'
  cache_sweeper :posts_sweeper, :only => [:create, :update, :destroy]

  before_filter :find_post,      :except => [:index, :create, :monitored, :search]
  before_filter :site_login_required, :except => [:index, :monitored, :search, :show]
  @@query_options = { :select => "#{ForumPost.table_name}.*, #{Topic.table_name}.title as topic_title, #{Forum.table_name}.name as forum_name", :joins => "inner join #{Topic.table_name} on #{ForumPost.table_name}.topic_id = #{Topic.table_name}.id inner join #{Forum.table_name} on #{Topic.table_name}.forum_id = #{Forum.table_name}.id" }

	# @WBH@ TODO: This uses the caches_formatted_page method.  In the main Beast project, this is implemented via a Config/Initializer file.  Not
	# sure what analogous place to put it in this plugin.  It don't work in the init.rb
  #caches_formatted_page :rss, :index, :monitored
  #cache_sweeper :posts_sweeper, :only => [:create, :update, :destroy]

  def index
    conditions = []
    [:user_id, :forum_id, :topic_id].each { |attr| conditions << ForumPost.send(:sanitize_sql, ["#{ForumPost.table_name}.#{attr} = ?", params[attr]]) if params[attr] }
    conditions = conditions.empty? ? nil : conditions.collect { |c| "(#{c})" }.join(' AND ')
    @posts = ForumPost.paginate @@query_options.merge(:conditions => conditions, :page => params[:page], :count => {:select => "#{ForumPost.table_name}.id"})
    @users = User.find(:all, :select => 'distinct *', :conditions => ['id in (?)', @posts.collect(&:user_id).uniq]).index_by(&:id)
    render_posts_or_xml
  end

  def search		
    conditions = params[:q].blank? ? nil : ForumPost.send(:sanitize_sql, ["LOWER(#{ForumPost.table_name}.body) LIKE ?", "%#{params[:q]}%"])
    @posts = ForumPost.paginate @@query_options.merge(:conditions => conditions, :page => params[:page], :count => {:select => "#{ForumPost.table_name}.id"}).order(post_order)
    @users = User.find(:all, :select => 'distinct *', :conditions => ['id in (?)', @posts.collect(&:user_id).uniq]).index_by(&:id)
    render_posts_or_xml :index
  end

  def monitored
    @user = User.find params[:user_id]
    options = @@query_options.merge(:conditions => ["#{Monitorship.table_name}.user_id = ? and #{ForumPost.table_name}.user_id != ? and #{Monitorship.table_name}.active = ?", params[:user_id], @user.id, true])
    options[:order]  = post_order
    options[:joins] += " inner join #{Monitorship.table_name} on #{Monitorship.table_name}.topic_id = #{Topic.table_name}.id"
    options[:page]   = params[:page]
    options[:count]  = {:select => "#{Post.table_name}.id"}
    @posts = ForumPost.paginate options
    render_posts_or_xml
  end

  def show
    respond_to do |format|
      format.html { redirect_to forum_topic_path(@post.forum_id, @post.topic_id) }
      format.xml  { render :xml => @post.to_xml }
    end
  end

  def create
    @topic = Topic.find_by_id_and_forum_id(params[:topic_id],params[:forum_id])
    if @topic.locked?
      respond_to do |format|
        format.html do
          flash[:notice] = 'This topic is locked.'[:locked_topic]
          redirect_to(forum_topic_path(:forum_id => params[:forum_id], :id => params[:topic_id]))
        end
        format.xml do
          render :text => 'This topic is locked.'[:locked_topic], :status => 400
        end
      end
      return
    end
    @forum = @topic.forum
    @post  = @topic.posts.build(params[:forum_post])
    @post.user = current_user
    @post.save!
    @post.notification.deliver
    respond_to do |format|
      format.html do
        redirect_to forum_topic_path(:forum_id => params[:forum_id], :id => params[:topic_id], :anchor => @post.dom_id, :page => params[:page] || '1')
      end
      format.xml { head :created, :location => post_url(:forum_id => params[:forum_id], :topic_id => params[:topic_id], :id => @post, :format => :xml) }
    end
  rescue ActiveRecord::RecordInvalid
    flash[:bad_reply] = 'Please post something at least...'[:post_something_message]
    respond_to do |format|
      format.html do
        redirect_to forum_topic_path(:forum_id => params[:forum_id], :id => params[:topic_id], :anchor => 'reply-form', :page => params[:page] || '1')
      end
      format.xml { render :xml => @post.errors.to_xml, :status => 400 }
    end
  end
  
  def edit
    respond_to do |format| 
      format.html
      format.js
    end
  end
  
  def update
    @post.attributes = params[:forum_post]
    @post.save!
  rescue ActiveRecord::RecordInvalid
    flash[:bad_reply] = 'An error occurred'[:error_occured_message]
  ensure
    respond_to do |format|
      format.html do
        redirect_to forum_topic_path(:forum_id => params[:forum_id], :id => params[:topic_id], :anchor => @post.dom_id, :page => params[:page] || '1')
      end
      format.js
      format.xml { head 200 }
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "Post has been deleted"
    end
    respond_to do |format|
      format.html do
        redirect_to(@post.topic.frozen? ? 
          forum_path(params[:forum_id]) :
          forum_topic_path(:forum_id => params[:forum_id], :id => params[:topic_id], :page => params[:page]))
      end
      format.xml { head 200 }
    end
  end

  protected
    def authorized?
      action_name == 'create' || @post.editable_by?(current_user)
    end
    
    def post_order
      "#{ForumPost.table_name}.created_at#{params[:forum_id] && params[:topic_id] ? nil : " desc"}"
    end
    
    def find_post			
		  begin
		    @post = ForumPost.find_by_id_and_topic_id_and_forum_id(params[:id], params[:topic_id], params[:forum_id]) || raise(ActiveRecord::RecordNotFound)
      rescue => e
        puts "############ Unexpected errors /n #{e.inspect}"
      end
    end
    
    def render_posts_or_xml(template_name = action_name)
      respond_to do |format|
        format.html { render :action => template_name }
        format.rss  { render :action => template_name, :layout => false }
        format.xml  { render :xml => @posts.to_xml }
      end
    end
end
