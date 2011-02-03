class Site::ProductsController < ApplicationController
  before_filter :store_location
  layout "site"

  def index
    @products = Product.find(:all)

  end

  def show

    @product = Product.find(params[:id]) || Product.find_by_id(params[:id])
    unless @product
      render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
   # end
    #unless @product.blank?
  else
    p "**************************"
    p params[:category]
    p "*************************"
   unless Category.find(@product.categories).blank?
    @category = Category.find(@product.categories.root.name)
  end
    p "******hjjh********************"
    p YAML::dump(@category)
    p "**************************"
    unless Category.find(@product.categories).blank?
    if @product.categories.root.name == "Hampers" or params[:category] == "mixed-case" or params[:category] == "wine-hampers"
      @images = @category.blank? ? [] : @category.products.find(:all,:order => "products.price DESC", :include => [:categories, :grapes]).paginate(:page => params[:page], :per_page => 10)

    end
  end

  end
  end

end

