class Site::ImagesController < ApplicationController

  before_filter :load_image

  def show
    image_type = params[:image_type].to_s
    respond_to do |format|
      format.html{}
      format.jpg do
        if available_image_types.include?(image_type) and @image.present?
          image_type = image_type.to_sym
          @image.operate do |image|

            image.resize '60x128' if image_type == :product_wine
          end
        else
          render :nothing => true
        end
      end
    end
  end

  private

  def load_image
    @image =  (params[:image_type].to_s == "avatar_thumb" or params[:image_type].to_s == "avatar_thumb_small") ? Photo.find(params[:image_id]) : Image.find(params[:id])
  end

  def available_image_types
    %w(category category_thumb home_image home_image_thumb product product_display product_wine product_food avatar_thumb avatar_thumb_small producer_thumb wine_category_producers_page
       product_hamper product_event product_thumb product_rec restaurant restaurant_thumb restaurant_thumb_site product_show
       recipe recipe_thumb post post_thumb review review_thumb news_letters_header news_letters_thumb news_letters_week
       news_letters_product news_letters_banner news_letters_other product_wine_tour blog_view product_thumb_cart product_thumb_carta grape_thumb region_thumb_small region_thumb about_thumb region_card wine_category community_producer_thumb wine_tour_category product_hamper_big food_category hamper_category food_sub_category hamper_sub_category wine_sub_category card product_wine_tour_left_images blog_banner)
  end
end

