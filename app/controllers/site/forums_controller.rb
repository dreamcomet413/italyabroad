class Site::ForumsController < ApplicationController
  layout 'site'

	before_filter :site_login_required, :except => [:index, :show]
  before_filter :find_or_initialize_forum, :except => :index
#before_filter :admin_login_required, :except => [:show, :index]
  before_filter :load_active_users, :only => [:index, :show]
  #cache_sweeper :posts_sweeper, :only => [:create, :update, :destroy]

  def index
    @enough_chars=195 # around 6 lines
    @forums = Forum.find_ordered
    # reset the page of each forum we have visited when we go back to index
    session[:forum_page] = nil
    respond_to do |format|
      format.html
      format.xml { render :xml => @forums }
    end
  end

  def show
    respond_to do |format|
      format.html do
        # keep track of when we last viewed this forum for activity indicators
        (session[:forums] ||= {})[@forum.id] = Time.now.utc if logged_in?
        (session[:forum_page] ||= Hash.new(1))[@forum.id] = params[:page].to_i if params[:page]

        @topics = @forum.topics.paginate :page => params[:page]
        User.find(:all, :conditions => ['id IN (?)', @topics.collect { |t| t.replied_by }.uniq]) unless @topics.blank?
      end
      format.xml { render :xml => @forum }
    end
  end

  def new
    render :layout => 'admin'
  end

  def edit
    render :layout => 'admin'
  end

  # new renders new.html.erb
  def create
    @forum.attributes = params[:forum]
    @forum.save!
    respond_to do |format|
      format.html { redirect_to admin_forums_path }
      format.xml  { head :created, :location => forum_url("/siteadmin/forums", :format => :xml) }
    end
  end

  def update
    @forum.update_attributes!(params[:forum])
    respond_to do |format|
      format.html { redirect_to admin_forums_path }
      format.xml  { head 200 }
    end
  end

  def destroy
    @forum.destroy
    respond_to do |format|
      format.html { redirect_to admin_forums_path }
      format.xml  { head 200 }
    end
  end

  protected
    def find_or_initialize_forum
      @forum = params[:id] ? Forum.find(params[:id]) : Forum.new
    end

    def load_active_users
      @active_users = User.find(:all, :limit => 10, :order => "posts_count")
    end

    alias authorized? admin?
end

