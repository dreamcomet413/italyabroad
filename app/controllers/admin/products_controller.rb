class Admin::ProductsController < ApplicationController
  before_filter :admin_login_required
  before_filter :store_location, :only => [:edit, :meta, :categories, :extra, :ideal_with, :how_to_cook, :correlation, :images, :files]

  layout "admin"

  def index
     categories = Category.find_by_sql("select * from categories where parent_id is null")
     @categories_data = Admin::CategoriesController.new
    @data = @categories_data.get_tree(categories,nil)
    if params[:update]  and !params[:discount].blank?
      @products = Product.find(:all, :include => [:categories],:conditions=>['categories.name LIKE ? AND products.name LIKE ? ',"%#{params[:search]}%" ,"%#{params[:search_name]}%"], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
      for product in @products
        @product = Product.find(product.id)
        @product.update_attribute('discount',params[:discount])

      end
    end
    if params[:search] or params[:update]
    @products = Product.find(:all, :include => [:categories],:conditions=>['categories.name LIKE ? AND products.name LIKE ? ',"%#{params[:search]}%" ,"%#{params[:search_name]}%"], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
  else
    @products = Product.find(:all, :include => [:categories], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
  end
 end


  def new
    @product = Product.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def destroy
    Product.find_by_id(params[:id]).destroy
    redirect_to :action => :index
  end

  def create
    @product = Product.new(params[:product])

    if @product.save
      redirect_to edit_admin_product_path(@product)
    else
      flash[:notice] = @product.show_errors
      render :action => :new
    end
  end

  def meta
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def categories
    @product = Product.find(params[:id])
    @categories = Category.tree(Category.roots, nil, @product)

    respond_to do |format|
      format.html
    end
  end

  def extra
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def ideal_with
    @product = Product.find(params[:id])
    @products = Product.find(:all, :conditions => ["products.id NOT IN (?)", @product.id])

    respond_to do |format|
      format.html
    end
  end

  def how_to_cook
    @product = Product.find(params[:id])
    @recipes = Recipe.find(:all)

    respond_to do |format|
      format.html
    end
  end

  def correlation
    @product = Product.find(params[:id])
    @products = Product.find(:all, :conditions => ["products.id NOT IN (?)", @product.id])

    respond_to do |format|
      format.html
    end
  end

  def images
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def files
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def update
    params[:product] ||= {}

    params[:product][:category_ids] = params[:category_ids] if params[:category_ids]
    params[:product][:correlation_ids] = params[:correlation_ids] if params[:correlation_ids]
    params[:product][:ideal_with_id] = params[:ideal_with_id] if params[:ideal_with_id]
    params[:product][:how_to_cook_id] = params[:how_to_cook_id] if params[:how_to_cook_id]
    params[:product][:included_product_ids] = params[:included_product_ids] if params[:included_product_ids]
    @product = Product.find(params[:id])

    @product.image_1.destroy if @product.image_1 && !params[:image_1].blank?
    @product.build_image_1(:image_file => params[:image_1]) unless params[:image_1].blank?

    @product.image_2.destroy if @product.image_2 && !params[:image_2].blank?
    @product.build_image_2(:image_file => params[:image_2]) unless params[:image_2].blank?

    @product.image_3.destroy if @product.image_3 && !params[:image_3].blank?
    @product.build_image_3(:image_file => params[:image_3]) unless params[:image_3].blank?

    @product.resource_1.destroy if @product.resource_1 && !params[:resource_1].blank?
    @product.build_resource_1(params[:resource_1]) unless params[:resource_1].blank?

    @product.resource_2.destroy if @product.resource_2 && !params[:resource_2].blank?
    @product.build_resource_2(params[:resource_2]) unless params[:resource_2].blank?

    @product.resource_3.destroy if @product.resource_3 && !params[:resource_3].blank?
    @product.build_resource_3(params[:resource_3]) unless params[:resource_3].blank?
    p ("===============")
p params[:product]

    if @product.update_attributes(params[:product])
      flash.now[:notice] = "Product is updated successfully"
      redirect_back_or_default(admin_products_path)
    else
      @product.image_1 = nil
      @product.image_2 = nil
      @product.image_3 = nil

      @product.resource_1 = nil
      @product.resource_2 = nil
      @product.resource_3 = nil

      flash.now[:notice] = @product.show_errors
      redirect_back_or_default(admin_products_path)
    end
  end

  def included_products

    @product = Product.find(params[:id])
    @products = Product.find(:all, :conditions => ["products.id NOT IN (?)", @product.id])

    respond_to do |format|
      format.html
    end
  end

  def xml
    @products = Product.find(:all)
     @xml = @products.to_xml(:only => [:name, :description_short,:price])
     File.open("products.xml", 'w') {|f| f.write(@xml) }
     send_file File.join(Rails.root,"products.xml" ), :type => "xml"
  end
 end

