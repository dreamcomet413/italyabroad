class Admin::PostsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @posts = Post.find(:all, :order => "created_at DESC").paginate(:per_page => 10, :page => params[:page])
  end

  def new
    @post = Post.new
    
    respond_to do |format|
      format.dialog { render :partial => 'new' }
      format.html
    end
  end

  def edit
    @post = Post.find(params[:id])
    
    respond_to do |format|
      format.dialog { render :partial => 'edit' }
      format.html
    end
  end

  def create
    @post = Post.new(params[:post])
    @post.tag_ids = Tag.find_or_create_by_names(params[:tags])
    
    @post.image_1.destroy if @post.image_1 && !params[:image_1].blank?
    @post.build_image_1(:image_file => params[:image_1]) unless params[:image_1].blank?

    @post.image_2.destroy if @post.image_2 && !params[:image_2].blank?
    @post.build_image_2(:image_file => params[:image_2]) unless params[:image_2].blank?

    @post.image_3.destroy if @post.image_3 && !params[:image_3].blank?
    @post.build_image_3(:image_file => params[:image_3]) unless params[:image_3].blank?
    
    @post.resource_1.destroy if @post.resource_1 && !params[:resource_1].blank?
    @post.build_resource_1(params[:resource_1]) unless params[:resource_1].blank?
    
    @post.resource_2.destroy if @post.resource_2 && !params[:resource_2].blank?
    @post.build_resource_2(params[:resource_2]) unless params[:resource_2].blank?
    
    @post.resource_3.destroy if @post.resource_3 && !params[:resource_3].blank?
    @post.build_resource_3(params[:resource_3]) unless params[:resource_3].blank?
    
    if @post.save
      redirect_to :action => :index
    else
      @post.image_1 = nil
      @post.image_2 = nil
      @post.image_3 = nil
      
      @post.resource_1 = nil
      @post.resource_2 = nil
      @post.resource_3 = nil
      
      flash[:notice] = @post.show_errors
      render :action => :new
    end

  end

  def destroy_image
    @post = Post.find(params[:id])

    case params[:img]
    when "1"
      @post.image_1.destroy
    when "2"
      @post.image_2.destroy
    when "3"
      @post.image_3.destroy
    end

    redirect_to :action => :edit, :id => @post
  end
  
  def destroy_resource
    @post = Post.find(params[:id])
    
    case params[:rsc]
    when "1"
      @post.resource_1.destroy
    when "2"
      @post.resource_2.destroy
    when "3"
      @post.resource_3.destroy
    end
    
    redirect_to :action => :edit, :id => @post
  end

  def update
    @post = Post.find(params[:id])
    @post.tag_ids = Tag.find_or_create_by_names(params[:tags])
    
    @post.image_1.destroy if @post.image_1 && !params[:image_1].blank?
    @post.build_image_1(:image_file => params[:image_1]) unless params[:image_1].blank?

    @post.image_2.destroy if @post.image_2 && !params[:image_2].blank?
    @post.build_image_2(:image_file => params[:image_2]) unless params[:image_2].blank?
    
    @post.image_3.destroy if @post.image_3 && !params[:image_3].blank?
    @post.build_image_3(:image_file => params[:image_3]) unless params[:image_3].blank?
    
    @post.resource_1.destroy if @post.resource_1 && !params[:resource_1].blank?
    @post.build_resource_1(params[:resource_1]) unless params[:resource_1].blank?
    
    @post.resource_2.destroy if @post.resource_2 && !params[:resource_2].blank?
    @post.build_resource_2(params[:resource_2]) unless params[:resource_2].blank?
    
    @post.resource_3.destroy if @post.resource_3 && !params[:resource_3].blank?
    @post.build_resource_3(params[:resource_3]) unless params[:resource_3].blank?

    if @post.update_attributes(params[:post])
      flash[:notice] = "Blog updated successfully"
    else
      @post.image_1 = nil
      @post.image_2 = nil
      @post.image_3 = nil
      
      @post.resource_1 = nil
      @post.resource_2 = nil
      @post.resource_3 = nil
      flash[:notice] = @post.show_errors
    end
    render :action => :edit
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to(admin_posts_path)
  end

end