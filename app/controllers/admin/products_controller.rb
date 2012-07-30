class Admin::ProductsController < ApplicationController
  before_filter :admin_login_required
  before_filter :store_location, :only => [:edit, :meta, :categories, :extra, :ideal_with, :how_to_cook, :correlation, :images, :files,:included_products]

  layout "admin"


  def index
     categories = Category.find_by_sql("select * from categories where parent_id is null")
     @categories_data = Admin::CategoriesController.new
    @data = @categories_data.get_tree(categories,nil)
    if !params[:search].blank?

      @products = Product.find(:all, :include => [:categories],:conditions=>['categories.id = ? AND products.name LIKE ? ',"#{params[:search]}" ,"%#{params[:search_name]}%"], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
      if params[:update] and !params[:discount].blank?
        update_discount(@products,params[:discount])
      end
      @products = Product.find(:all, :include => [:categories],:conditions=>['categories.id = ? AND     products.name LIKE ? ',"#{params[:search]}" ,"%#{params[:search_name]}%"], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
  elsif params[:search].blank?
      @products = Product.find(:all, :include => [:categories],:conditions=>[' products.name LIKE ? ',"%#{params[:search_name]}%"], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
      if params[:update] and !params[:discount].blank?
        update_discount(@products,params[:discount])
      end
      @products = Product.find(:all, :include => [:categories],:conditions=>[' products.name LIKE ? ',"%#{params[:search_name]}%"], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
  else
      @products = Product.find(:all, :include => [:categories], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
      if params[:update] and !params[:discount].blank?
       update_discount(@products,params[:discount])
      end
     @products = Product.find(:all,:include => [:categories], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
  end

   if params[:inactive]
       if !params[:search].blank?
         logger.info "Inactive products"
         @products = Product.find(:all, :include => [:categories],:conditions=>['categories.id = ? AND products.name LIKE ? and active = ? ',"#{params[:search]}" ,"%#{params[:search_name]}%",false], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
      elsif params[:search].blank?
        @products = Product.find(:all, :include => [:categories],:conditions=>['products.name LIKE ? and active = ? ',"%#{params[:search_name]}%",false], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)
      end
  end

 end

 def products_sortby_quantity

   if !params[:search_name].blank?

    @products = Product.find(:all, :conditions=>['quantity <= ? ',"#{params[:search_name]}"], :order => "quantity DESC").paginate(:page => params[:page], :per_page => 20)
  else
    @products = Product.find(:all, :order => "quantity DESC").paginate(:page => params[:page], :per_page => 20)
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
    Product.find(params[:id]).destroy
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
    @product = Product.find(params[:id])
    params[:product] ||= {}

    params[:product][:category_ids] = params[:category_ids] if params[:category_ids]
    if params[:category_ids]
      params[:category_ids].each do |cat_id|
        @c = Category.find(cat_id)
           unless params[:category_ids].include?(@c.root.id)
             params[:product][:category_ids].push(@c.root.id)
           end
      end
    end
  # params[:product][:correlation_ids] = params[:correlation_ids] if params[:correlation_ids]

  # this is not restful. if params[:h_corelation] condition added to avoid deletion of inlcuded product_ids while updating correlation or any other attribute of product throught his interface
  params[:product][:correlation_ids] = params[:correlation_ids] if params[:h_corelation]


    params[:product][:ideal_with_id] = params[:ideal_with_id] if params[:ideal_with_id]
    params[:product][:how_to_cook_id] = params[:how_to_cook_id] if params[:how_to_cook_id]
 #  params[:product][:included_product_ids] = params[:included_product_ids] if params[:included_product_ids]

  # this is not restful. if params[:h_inc_products] condition added to avoid deletion of correlation_ids while updating included products or any other attribute of product throught his interface
    params[:product][:included_product_ids] = params[:included_product_ids] if params[:h_inc_products]


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
   # p ("===============")
#p params[:product]

    if @product.update_attributes(params[:product])
      color = params[:product][:color]
      if color
        color = color.gsub(/[\W]/,' ')
        color = color.strip
        color = color.capitalize
      end

      @product.update_attribute('color',"#{color}")
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
    p_ids = []
    @product = Product.find(params[:id])
    if !params[:search_name].blank?
      if @product.root_category == 'Hampers' || @product.sub_categories.include?('Mixed case')
        @products = Product.find(:all, :conditions => ["products.id NOT IN (?)  AND quantity > ? AND active = ? AND products.name LIKE ? ", @product.id,0,true,"%#{params[:search_name]}%"])
      else
        @products = Product.find(:all, :include=>['categories'],:conditions => ["products.id NOT IN (?) AND LOWER(categories.name) = ? AND quantity > ? AND active = ? AND products.name LIKE ? ", @product.id,'wine',0,true,"%#{params[:search_name]}%"])
      end

    @products.each do |p|
      p_ids.push(p.id)
    end
    if @product.included_product_ids
    for included_product_id in @product.included_product_ids
      unless p_ids.include?(included_product_id)
        @products << Product.find_by_id(included_product_id)
      end
    end
    end

    # @products = Product.find(:all,:conditions => ["products.id NOT IN (?)", @product.id])
    else
      if @product.root_category == 'Hampers' || @product.sub_categories.include?('Mixed case')
         @products = Product.find(:all,:conditions => ["products.id NOT IN (?) AND quantity > ? AND active = ?", @product.id,0,true])
      else
         @products = Product.find(:all, :include=>'categories',:conditions => ["products.id NOT IN (?) AND LOWER(categories.name) = ? AND quantity > ? AND active = ?", @product.id,'wine',0,true])
      end


    end

    respond_to do |format|
      format.html
    end
  end

  def xml
 item_string = ""
 whole_product = ""
    @products = Product.find(:all)
   header_string = '<?xml version="1.0" encoding="UTF-8" ?>'
  header_string += '<rss version ="2.0" xmlns:g="http://base.google.com/ns/1.0">'
  header_string += '<channel>'
  header_string += '<title>Products Data</title>'
 # header_string += '<description>Details of the product</description>'
  header_string += '<link>http://www.example.com</link>'
  footer_string = '</channel>'
  footer_string +='</rss>'
  #   @xml = @products.to_xml(:only => [:name, :description_short,:price])
   #  File.open("products.xml", 'w') {|f| f.write(@xml) }
    for product in @products
      item_string += '<item>'
      item_string += '<g:id>'+ product.id.to_s + '</g:id>'
      item_string += '<title>Title</title>'
      item_string += '<g:condition>new</g:condition>'
      item_string += '<g:quantity>'+ product.quantity.to_s + '</g:quantity>'
      item_string += '<name>'+ h(product.name) + '</name>'
      item_string += '<description>'+ h(product.description) + '</description>'

     item_string += '<link>' + h(url_for(:only_path => false, :controller => "site/products", :action => "show", :id =>"#{product.friendly_identifier}"))  + '</link>'
      item_string += '<g:price>'+ product.price.to_s + '</g:price>'
      item_string += '<rate>'+ product.rate.to_s + '</rate>'
      item_string += '</item>'
     end

    whole_product = header_string + item_string + footer_string
    File.open("products.xml", 'w') {|f| f.write(whole_product) }
    send_file File.join(Rails.root,"products.xml" ), :type => "xml"
  end

  def update_discount(products,discount)
     for product in products

        @product = Product.find(product.id)
        @product.update_attribute('discount',discount)

      end
  end

  def products_of_the_week
  #  @products = Product.all
   # @week_product_ids = WeekProduct.find(:all)
 categories = Category.find_by_sql("select * from categories where parent_id is null")
     @categories_data = Admin::CategoriesController.new
    @data = @categories_data.get_tree(categories,nil)


    if !params[:search].blank?

      @products = Product.find(:all, :include => [:categories],:conditions=>['categories.id = ? AND products.name LIKE ? AND(UPPER(categories.name) = ? OR UPPER(categories.name = ?)) and products.id NOT IN (select week_product_id from week_products) ',"#{params[:search]}" ,"%#{params[:search_name]}%",'WINE','FOOD']).paginate(:page => params[:page], :per_page => 20)
  elsif params[:search].blank?
    @products = Product.find(:all, :include => [:categories],:conditions=>['products.name LIKE ? AND(UPPER(categories.name) = ? OR UPPER(categories.name = ?)) and products.id NOT IN (select week_product_id from week_products)',"%#{params[:search_name]}%",'WINE','FOOD']).paginate(:page => params[:page], :per_page => 20)

  else
      @products = Product.find(:all,:include => [:week_products],:conditions=>['UPPER(categories.name) = ? OR UPPER(categories.name = ?) and products.id NOT IN (select week_product_id from week_products)','Wine','FOOD'],:include => [:categories]).paginate(:page => params[:page], :per_page => 20)

  end
    if params[:id] and request.xhr?
      WeekProduct.find_or_create_by_week_product_id(params[:id])
    end
  end

  def delete_products_of_the_week
    @week_products = WeekProduct.find(:all)
     if params[:id] and request.xhr?
       @week_product = WeekProduct.find_by_week_product_id(params[:id])
       @week_product.destroy
     end
  end

  def remove_all_correlations
    @product = Product.find(params[:id])
    unless @product.correlation_ids.nil?
      @product.correlation_ids.each do |inc_id|
        @relation = ProductCorrelation.find_by_correlation_id_and_product_id(inc_id,@product.id)
        @relation.delete
      end
    end
    redirect_to product_correlation_path(@product)
  end
 end

