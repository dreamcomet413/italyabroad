class Site::CartController < ApplicationController
  layout "site"
  
  def index 
    @cupon = @cart.cupon
    @delivery = @cart.delivery
    @buy_together_discount = @cart.buy_together_discount
  end
  
  def create
    created = @cart.create(product, quantity)
    if created
      status = "#{product.name} correctly added to your cart."
    else
      status = @cart.show_warnings
    end

    respond_to do |format|
      format.html do 
        flash[:notice] = status
        redirect_back_or_default(cart_index_path)
      end
      
      format.js do
        render :update do |page|
          page.replace_html 'cart', :partial => "/site/shared/cart"
          page.replace_html 'promotion', :partial => "/site/shared/promotion"
          page.visual_effect :highlight, 'cart', :startcolor => "#FFA800", :endcolor => "#c1d830"
          page << "alert('#{status}')"
        end
      end
    end
  end
  
  def update
    if @cart.update(params[:cart], params[:cupon][:code], params[:delivery][:id])
      flash[:notice] = @cart.show_warnings
    else
      flash[:notice] = @cart.show_errors
    end
    redirect_to :action => :index
  end
  
  def empty
    session[:cart] = nil
    redirect_to :action => :index
  end

  def continue_shopping
    redirect_back_or_default root_url
  end
  
  def destroy
    @cart.destroy(product_id)
    redirect_to :action => :index
  end
  
  private

  def quantity
    return params[:cart][:quantity] if params[:cart] && params[:cart][:quantity]
    return 1
  end

  def product_id
    return params[:product_id] if params[:product_id]
    return params[:recipe_id] if params[:recipe_id]
  end
  
  def product
    return Recipe.find(params[:recipe_id]) if params[:recipe_id]
    return Product.find(params[:product_id]) if params[:product_id]
  end
end
