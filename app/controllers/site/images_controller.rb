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
            #image.resize '60x128', :crop => true if image_type == :wine_category
            #image.resize '80x150' if image_type == :wine_category
            #image.resize '80x150', :crop => true if image_type == :wine_category


            #image.resize '80x150', :crop => true if image_type == :wine_category
            image.resize '100' if image_type == :wine_category




            image.resize '80x150' if image_type == :wine_category_producers_page


            # added by indu on august 2001, according to mail July 29, 2011, 12:44 PM subject - RE: Important - need your help
            image.resize '120x150 ' if image_type == :food_category
            image.resize '120x150 ' if image_type == :food_sub_category
#            image.resize '120x150 ' if image_type == :hamper_category
            image.resize '80' if image_type == :hamper_category
            image.resize '120x150 ' if image_type == :hamper_sub_category
            image.resize '80x150', :crop => true if image_type == :wine_sub_category


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

            image.resize '250' if image_type == :card   #product_show


            image.resize '60x128' if image_type == :product_wine
            #image.resize '60x128' if image_type == :product_food
            #image.resize '80x150', :crop => true if image_type == :product_food
            image.resize '100' if image_type == :product_food
            #commented by indu to change the hamper image size as his request on July 26, 2011 by mail subject-sitemap
           # image.resize '70x90', :crop => true if image_type == :product_hamper
            image.resize '120x120', :crop => true if image_type == :product_hamper_big
            image.resize '70x90', :crop => true if image_type == :product_event
            image.resize '65x190' if image_type == :product_thumb
            image.resize '30x30' if image_type == :product_thumb_cart
            image.resize '65x100', :crop => true if image_type == :product_thumb_carta


            image.resize '100x100' if image_type == :product_rec
            image.resize '237x180' if image_type == :product_wine_tour
            #image.resize '315' if image_type == :product_wine_tour_left_images
            image.resize '200', :crop => true if image_type == :product_wine_tour_left_images

            image.resize '237x180' if image_type == :wine_tour_category
            image.resize '300x300' if image_type == :product_show
            #image.resize '480x450' if image_type == :recipe
            image.resize '100x75', :stretch => true, :upsample => true if image_type == :recipe_thumb

            image.resize '100x75', :crop => true if image_type == :post_thumb
            image.resize '480x450', :crop => true if image_type == :post

            image.resize '100x75', :stretch => true, :upsample => true if image_type == :restaurant_thumb
            image.resize '250x200' if image_type == :restaurant_thumb_site

            #image.resize '480x450' if image_type == :recipe
            image.resize '150x150' if image_type == :recipe
            image.resize '100x75', :stretch => true, :upsample => true if image_type == :recipe_thumb

            image.resize '100x75' if image_type == :review_thumb

            image.resize '287x200' if image_type == :blog_view
            image.resize '723x284',:crop=>true if image_type == :blog_banner

            image.resize '300x300',:crop=>true if image_type == :producer_thumb
            image.resize '300x300',:crop=>true if image_type == :region_thumb
            image.resize '100x100',:crop=>true if image_type == :region_thumb_small
            #image.resize '300x300',:crop=>true if image_type == :about_thumb
            image.resize '723x284',:crop=>true if image_type == :about_thumb
            image.resize '723x284',:crop=>true if image_type == :region_card
           # image.resize '98x98',:crop=>true if image_type == :community_producer_thumb
           # image.resize '210x79',:crop=>true if image_type == :community_producer_thumb
            image.resize '150x150',:crop=>true if image_type == :community_producer_thumb




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
    %w(category category_thumb home_image home_image_thumb product product_display product_wine product_food avatar_thumb avatar_thumb_small producer_thumb wine_category_producers_page
       product_hamper product_event product_thumb product_rec restaurant restaurant_thumb restaurant_thumb_site product_show
       recipe recipe_thumb post post_thumb review review_thumb news_letters_header news_letters_thumb news_letters_week
       news_letters_product news_letters_banner news_letters_other product_wine_tour blog_view product_thumb_cart product_thumb_carta grape_thumb region_thumb_small region_thumb about_thumb region_card wine_category community_producer_thumb wine_tour_category product_hamper_big food_category hamper_category food_sub_category hamper_sub_category wine_sub_category card product_wine_tour_left_images blog_banner)
  end
end
