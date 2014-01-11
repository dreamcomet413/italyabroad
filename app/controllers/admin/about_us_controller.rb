class Admin::AboutUsController < ApplicationController
  before_filter :admin_login_required
  layout "admin"
  # GET /about_us
  # GET /about_us.xml
  def index
    p params
    p params[:type]
    @about_us = AboutU.find(:first,:conditions => {:link_type => params[:type]})
    if @about_us.blank?
      redirect_to new_admin_about_u_path(:type => params[:type], :page_type => params[:page_type])
    else
      #      @about_us = AboutU.all
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @about_u }
    end
  end

  # GET /about_us/1/edit
  def edit
    @about_u = AboutU.find(params[:id])
  end

  # POST /about_us
  # POST /about_us.xml
  def create
    @about_u = AboutU.new(params[:about_u])
    unless params[:image].nil?
          @image = Image.new(params[:image])
          @image.save
          @about_u.image_id = @image.id
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
     unless params[:image].nil?
          @image = Image.new(params[:image])
          @image.save
          @about_u.image_id = @image.id
        end
    if @about_u.update_attributes(params[:about_u])

      flash[:notice] = 'Data is successfully updated.'
      redirect_to admin_about_us_path(:type => @about_u.link_type)
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
