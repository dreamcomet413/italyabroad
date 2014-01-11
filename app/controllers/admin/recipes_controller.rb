class Admin::RecipesController < ApplicationController
  before_filter :admin_login_required
  before_filter :store_location, :only => [:edit, :meta, :extra, :wine, :correlation, :images, :files]

  layout "admin"

  def index
     if params[:search]
       @recipes = Recipe.all(:conditions=>['name LIKE ?',"%#{params[:search_text]}%"],:order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
     else
    @recipes = Recipe.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
    end

    respond_to do |format|
      format.html
    end
  end

  def xml
     @recipes = Recipe.all.to_xml
      File.open("recipes.xml", 'w') {|f| f.write(@recipes) }
      send_file File.join(Rails.root,"recipes.xml" )
  end



  def new
    @recipe = Recipe.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def create
    @recipe = Recipe.new(params[:recipe])

    if @recipe.save
      redirect_to edit_admin_recipe_path(@recipe)
    else
      flash[:notice] = @recipe.show_errors
      render :action => :new
    end
  end

  def update
    params[:recipe] ||= {}
    params[:recipe][:correlation_ids] = params[:correlation_ids] if params[:correlation_ids]

    @recipe = Recipe.find(params[:id])


    @recipe.image_1.destroy if @recipe.image_1 && !params[:image_1].blank?
    @recipe.build_image_1(:image_file => params[:image_1]) unless params[:image_1].blank?

    @recipe.image_2.destroy if @recipe.image_2 && !params[:image_2].blank?
    @recipe.build_image_2(:image_file => params[:image_2]) unless params[:image_2].blank?

    @recipe.image_3.destroy if @recipe.image_3 && !params[:image_3].blank?
    @recipe.build_image_3(:image_file => params[:image_3]) unless params[:image_3].blank?


    @recipe.resource_1.destroy if @recipe.resource_1 && !params[:resource_1].blank?
    @recipe.build_resource_1(params[:resource_1]) unless params[:resource_1].blank?

    @recipe.resource_2.destroy if @recipe.resource_2 && !params[:resource_2].blank?
    @recipe.build_resource_2(params[:resource_2]) unless params[:resource_2].blank?

    @recipe.resource_3.destroy if @recipe.resource_3 && !params[:resource_3].blank?
    @recipe.build_resource_3(params[:resource_3]) unless params[:resource_3].blank?

    if @recipe.update_attributes(params[:recipe])
      flash.now[:notice] = "Recipe is updated successfully"
    else
      @recipe.image_1 = nil
      @recipe.image_2 = nil
      @recipe.image_3 = nil

      @recipe.resource_1 = nil
      @recipe.resource_2 = nil
      @recipe.resource_3 = nil

      flash.now[:notice] = @recipe.show_errors
    end

    redirect_back_or_default(admin_recipes_path)
  end

  def destroy
    Recipe.find_by_id(params[:id]).destroy
    redirect_to :action => :index
  end

  def meta
    @recipe = Recipe.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def extra
    @recipe = Recipe.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def wine
    @recipe = Recipe.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def correlation
    @recipe = Recipe.find(params[:id])
    @products = @recipe.all_product_with_that_are_related

    respond_to do |format|
      format.html
    end
  end

  def images
    @recipe = Recipe.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def files
    @recipe = Recipe.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
end