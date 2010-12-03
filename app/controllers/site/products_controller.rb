class Site::ProductsController < ApplicationController
  before_filter :store_location
  layout "site"
  
  def show
    
    @product = Product.find(params[:id]) || Product.find_by_id(params[:id])
    unless @product
      render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
    end

    p "**************************"
    p params[:category]
    p "*************************"
    @category = Category.find(@product.categories.root.name)
    p "******hjjh********************"
    p YAML::dump(@category)
    p "**************************"
    if @product.categories.root.name == "Hampers" or params[:category] == "mixed-case" or params[:category] == "wine-hampers"
      @images = @category.blank? ? [] : @category.products.find(:all,:order => "products.price DESC", :include => [:categories, :grapes]).paginate(:page => params[:page], :per_page => 10)

    end

  end

end
