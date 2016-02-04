class Site::ProductsController < ApplicationController
  before_filter :store_location
  layout "site"

  def index
    @products = Product.find(:all)

  end

  def show
    @product = Product.find(params[:id]) || Product.find_by_id(params[:id])
    if @product.present?
      @quantity = @product.get_quantity(params[:actual_price])
      @limited_stock =
        if @product.product_prices.empty?
          ""
        elsif @quantity.to_i <= Product::LIMITED_QUANTITY
          "Only #{@quantity} left in stock."
        end
          #(@product.present? and @product.quantity.to_i < 12) ? "Only #{quantity} left in stock." : ""
      unless @product.nil?
        if !@product.active
          flash[:alert]  = 'The Product is not available now'
          redirect_to root_url
        end
      end
    else
      flash[:alert]  = 'Product not found'
    end

    unless @product
      render :file => File.join(Rails.root, 'public', '404.html'), :status => 404
      # end
      #unless @product.blank?
    else
      p "**************************"
      p params[:category]
      p "*************************"
      if !@product.root_category_id.blank? && !Category.find(@product.categories.map(&:id)).blank?
        @category = Category.find(@product.categories.root.name)
      end
      if (@product && @product.root_category_id.blank? && !@product.sub_category_id.blank? && Category.find(@product.categories.first.parent_id).name == "Food")
        @category = Category.find(params[:category])
      end
      p "******hjjh********************"
      p YAML::dump(@category)
      p "**************************"
      if !@product.root_category_id.blank? && Category.find(@product.categories.map(&:id)).blank?
        if @product.categories.root.name == "Hampers" or params[:category] == "mixed-case" or params[:category] == "wine-hampers"
          @images = @category.blank? ? [] : @category.products.where("id is not null").includes([:categories, :grapes]).order("products.price DESC").
              paginate(:page => params[:page], :per_page => 10)
        end
      elsif (@product && @product.root_category_id.blank? && !@product.sub_category_id.blank? && Category.find(@product.categories.first.parent_id).name == "Food")
          @images = @category.blank? ? [] : @category.products.includes([:categories, :grapes]).order("products.price DESC").
              paginate(:page => params[:page], :per_page => 10)
        end
    end

  end

  def invite_a_friend
    if params[:your_friend_email].nil? or params[:your_message].nil? or params[:your_name].nil?
      flash[:notice] = "Your name or Friend's email or Message is missing. Please enter the required fields and continue"
      redirect_to params[:h_product_id]
    else
      Notifier.deliver_invite_a_friend(params[:your_friend_email],params[:your_name],params[:your_friend_name],params[:your_message])
      redirect_to params[:h_product_id]
    end

  end

  def wine_of_the_week
    @product = Product.find(params[:id])
  end

  def food_of_the_week
    @product = Product.find(params[:id])
  end

end

