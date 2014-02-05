class Admin::MoodsController < ApplicationController

  before_filter :admin_login_required
  layout "admin"

  def index
    @moods = Mood.all()
  end

  def new
    @mood = Mood.new()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mood }
    end
  end

  def create
    @mood = Mood.new(params[:mood])

    respond_to do |format|
      if @mood.save
        flash[:notice] = 'Mood was successfully created.'
        format.html { redirect_to(admin_moods_index_path) }
        format.xml  { render :xml => @mood, :status => :created, :location => @mood }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mood.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @mood = Mood.find(params[:id])
  end

  def update
    @mood = Mood.find(params[:id])

    respond_to do |format|
      if @mood.update_attributes(params[:mood])
        flash[:notice] = 'Mood was successfully updated.'
        format.html { redirect_to(admin_moods_index_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mood.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @mood = Mood.find(params[:id])
    @mood.destroy

    respond_to do |format|
      format.html { redirect_to(admin_moods_index_path) }
      format.xml  { head :ok }
    end
  end

end
