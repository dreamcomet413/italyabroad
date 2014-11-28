class Site::ProductsController < ApplicationController
  before_filter :store_location
  layout "site"

  def index
    @products = Product.find(:all)

  end

  def show
    @product = Product.find(params[:id]) || Product.find_by_id(params[:id])
    if @product.present?
      quantity =
        if params[:actual_price].present?
          @product.product_prices.find_by_price(params[:actual_price]).quantity.to_s
        else
          @product.product_prices.map(&:quantity).try(:first)
        end
      @limited_stock =
        if @product.product_prices.empty?
          ""
        elsif quantity.to_i <= 24
          "Only #{quantity} left in stock."
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
      unless Category.find(@product.categories.map(&:id)).blank?
        @category = Category.find(@product.categories.root.name)
      end
      p "******hjjh********************"
      p YAML::dump(@category)
      p "**************************"
      unless Category.find(@product.categories.map(&:id)).blank?
        if @product.categories.root.name == "Hampers" or params[:category] == "mixed-case" or params[:category] == "wine-hampers"
          @images = @category.blank? ? [] : @category.products.where("id is not null").includes([:categories, :grapes]).order("products.price DESC").
              paginate(:page => params[:page], :per_page => 10)
        end
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

