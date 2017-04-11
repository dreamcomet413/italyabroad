class Admin::AboutUsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"
  # GET /about_us
  # GET /about_us.xml
  def index
    p params
    p params[:link_type]
    if params[:link_type] and !params[:type]
      params[:type]=params[:link_type]
    end
    
    @about_us = AboutU.find_by_link_type(params[:type])

    unless @about_us.present?
      redirect_to new_admin_about_u_path(:type => params[:type], :page_type => params[:page_type])
    else
      redirect_to edit_admin_about_u_path(:id => @about_us.id, :type => params[:type])
    end

  end

  # GET /about_us/1
  # GET /about_us/1.xml
  def show
    @about_u = AboutU.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @about_u }
    end
  end

  # GET /about_us/new
  # GET /about_us/new.xml
  def new
    @about_u = AboutU.new
    @meta_type = ['grape-guide','producers','region','corporate services','Wholesale','blog']
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @about_u }
    end
  end

  # GET /about_us/1/edit
  def edit
    @about_u = AboutU.find(params[:id])
    @meta_type = ['grape-guide','producers','region','corporate services','Wholesale','blog']
  end

  # POST /about_us
  # POST /about_us.xml
  def create
    @about_u = AboutU.new(params[:about_u])
    if params[:image].present?
      #@about_u.image.destroy unless @about_u.image.nil?
      @about_u.build_image(:image_filename => params[:image])
    end
    respond_to do |format|
      if @about_u.save

        flash[:notice] = 'Content is successfully created.'
        format.html { redirect_to admin_about_us_path(:type =>@about_u.link_type ) }
        format.xml  { render :xml => admin_about_us_path, :status => :created, :location => @about_u }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @about_u.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /about_us/1
  # PUT /about_us/1.xml
  def update
    @about_u = AboutU.find(params[:id])
    if @about_u.valid? and  params[:image].present?
      #@about_u.image.destroy unless @about_u.image.nil?
      @about_u.build_image(:image_filename => params[:image])
    end
    if @about_u.update_attributes(params[:about_u])
      flash[:notice] = 'Data is successfully updated.'
      redirect_to admin_about_us_path(:link_type => @about_u.link_type)
    else
      render :action => "edit"
       
    end
  end

  # DELETE /about_us/1
  # DELETE /about_us/1.xml
  def destroy
    @about_u = AboutU.find(params[:id])
    @about_u.destroy

    respond_to do |format|
      format.html { redirect_to(siteadmin_path) }
      format.xml  { head :ok }
    end
  end
end

