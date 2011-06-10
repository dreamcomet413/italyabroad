class Site::ImagesController < ApplicationController

  before_filter :load_image

  def show
    image_type = params[:image_type].to_s

    respond_to do |format|
      if available_image_types.include?(image_type)
        image_type = image_type.to_sym
        format.jpg do
          @image.operate do |image|

            #IMPORTANT THESE TYPES DEFINED SHOULD BE MENTIONED IN THE FUNCTION DEFINED IN THE BOTTOM ..

            image.resize '65x104', :crop => true if image_type == :grape_thumb
            image.resize '50x50', :crop => true if image_type == :avatar_thumb_small
            image.resize '98x98', :crop => true if image_type == :avatar_thumb
            # image.resize '723x284', :stretch => false, :upsample => false if image_type == :home_image
            image.resize '723x284' if image_type == :home_image
            image.resize '100x75', :crop => true if image_type == :home_image_thumb

            image.resize '500x270', :stretch => false, :upsample => false if image_type == :category
            image.resize '100x75', :crop => true if image_type == :category_thumb
            image.resize '200x200', :crop => true if image_type == :product
            image.resize '800x600' if image_type == :product_display
            image.resize '60x128' if image_type == :product_wine
            image.resize '60x128' if image_type == :product_food
            image.resize '70x90', :crop => true if image_type == :product_hamper
            image.resize '70x90', :crop => true if image_type == :product_event
            image.resize '65x190' if image_type == :product_thumb
            image.resize '30x30' if image_type == :product_thumb_cart
            image.resize '100x100' if image_type == :product_rec
            image.resize '237x180' if image_type == :product_wine_tour
            image.resize '300x300' if image_type == :product_show
            image.resize '480x450' if image_type == :recipe
            image.resize '100x75', :stretch => true, :upsample => true if image_type == :recipe_thumb

            image.resize '100x75', :crop => true if image_type == :post_thumb
            image.resize '480x450', :crop => true if image_type == :post

            image.resize '100x75', :stretch => true, :upsample => true if image_type == :restaurant_thumb
            image.resize '250x200' if image_type == :restaurant_thumb_site

            image.resize '480x450' if image_type == :recipe
            image.resize '100x75', :stretch => true, :upsample => true if image_type == :recipe_thumb

            image.resize '100x75' if image_type == :review_thumb

            image.resize '287x200' if image_type == :blog_view
            image.resize '300' if image_type == :producer_thumb
          end
        end unless @image.blank?
      else
        format.jpg
      end
    end
  end

  private

  def load_image
    @image =  (params[:image_type].to_s == "avatar_thumb" or params[:image_type].to_s == "avatar_thumb_small") ? Photo.find(params[:id]) : Image.find(params[:id])
  end

  def available_image_types
    %w(category category_thumb home_image home_image_thumb product product_display product_wine product_food avatar_thumb avatar_thumb_small producer_thumb
       product_hamper product_event product_thumb product_rec restaurant restaurant_thumb restaurant_thumb_site product_show
       recipe recipe_thumb post post_thumb review review_thumb news_letters_header news_letters_thumb news_letters_week
       news_letters_product news_letters_banner news_letters_other product_wine_tour blog_view product_thumb_cart grape_thumb)
  end
end

