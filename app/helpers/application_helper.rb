# -*- coding: utf-8 -*-
# nasty hack used to handle new category routes
module ApplicationHelper

  def avatar_for_user(user, size="big", imgSize="100px")
    image = (size=="big") ? "default_big.jpg" : "default.jpg"
    unless user.nil?
      if user.has_default_photo?
        image = user.get_photo_default(size)
      elsif user.has_photo?
        image = user.photo.image_filename.url if user.photo.image_filename.present? && user.photo.image_filename.url.present?
      end
    end
    content_tag(:div, image_tag(image,:style => "width:#{imgSize}"), :class => "user_photo_#{size}", :id => "user_photo")
  end

  def humanize_date(date)
    date.strftime("%d %b %Y")
  end

  def set_title(title)
    @title = title
  end

  def set_focus_to(id)
    javascript_tag("$('#{id}').focus()");
  end

  def w3c_date(date)
    date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end

  def options_for_shipping_addresses(user)
    options = []
    options = user.ship_addresses.inject([["Use Profile Address",0]]) { |options, s| options << [s.code, s.id] }
    options << ["[Create a new address]", -1]
  end

  def title
    return  @title + " - Italyabroad.com" unless @title.blank?
    return "Discover the finest Italian food and wine made by small producers at Italyabroad.com"
  end

  def description
    return @description unless @description.blank?
    return "The best and finest Italian food and wine, olive oil,modena balsamic vinegar, cakes,  and much more"
  end

  def keys
    return @keys unless @keys.blank?
    return "The best and finest Italian food and wine, wine, food, red wine, white wine, rose wine, sparkling wine, dessert wine, vintage wine, fine wine, wines, foods, red wines, white wines, rose wines, sparkling wines, dessert wines, vintage wines, fine wines, authentic Italian product, finest Italian food, finest Italian wine, fine Italian wine, Italian food product, typical Italian product, finest Italian food in the UK, fine Italian food, Italian deli Newcastle, Italian desserts, Italian deli north east, Italian delicatessen north east, Italian wines north east, Italian extra virgin olive oil, Italian organic products, Italian organic wines, Italian wines Newcastle, award winning Italian wines, enoteca in the UK, Italian gift, Italian hampers, Italian deli online, hamper with Italian products, hampers free delivery, wine gift basket, strawberry wine, Italian food, organic hampers, gift baskets, anniversary gifts, Christmas gifts, gift hamper England, corporate hampers, panettone, pandoro, torrone, amaretti, Chianti Classico, Chianti riserva, Vino Nobile di Montepulciano, frascati, small producers, Modena balsamic vinegar, extra virgin olive oil, events, wine tasting, corporate, corporate gifts, corporate hampers, wine experts"
  end

  def truncate_words(text, length = 30, end_string=" …")
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end

  def ajax_spinner_for(id, spinner="spinner.gif")
    "<img src='/images/savage_beast/#{spinner}' style='display:none; vertical-align:middle;' id='#{id.to_s}_spinner'> "
  end

  def avatar_for(user, size=32)
    begin
      image_tag "http://www.gravatar.com/avatar.php?gravatar_id=#{MD5.md5(user.email)}&rating=PG&size=#{size}", :size => "#{size}x#{size}", :class => 'photo'
    rescue
      image_tag "http://www.gravatar.com/avatar.php?rating=PG&size=#{size}", :size => "#{size}x#{size}", :class => 'photo'
    end
  end

  def beast_user_name
    (current_user ? current_user.display_name : "Guest" )
  end

  def beast_user_link
    user_link = (current_user ? user_path(current_user) : "#")
    link_to beast_user_name, user_link
  end

  def feed_icon_tag(title, url)
    (@feed_icons ||= []) << { :url => url, :title => title }
    link_to image_tag('savage_beast/feed-icon.png', :size => '14x14', :style => 'margin-right:5px', :alt => "Subscribe to #{title}"), url
  end

  def search_posts_title
    returning(params[:q].blank? ? 'Recent Posts'[] : "Searching for"[] + " '#{h params[:q]}'") do |title|
      title << " "+'by {user}'[:by_user,h(User.find(params[:user_id]).display_name)] if params[:user_id]
      title << " "+'in {forum}'[:in_forum,h(Forum.find(params[:forum_id]).name)] if params[:forum_id]
    end
  end

  def topic_title_link(topic, options)
    if topic.title =~ /^\[([^\]]{1,15})\]((\s+)\w+.*)/
      "<span class='flag'>#{$1}</span>" +
          link_to(h($2.strip), forum_topic_path(@forum, topic), options)
    else
      link_to(h(topic.title), forum_topic_path(@forum, topic), options)
    end
  end

  def search_posts_path(rss = false)
    options = params[:q].blank? ? {} : {:q => params[:q]}
    options[:format] = 'rss' if rss
    [[:user, :user_id], [:forum, :forum_id]].each do |(route_key, param_key)|
      return send("#{route_key}_posts_path", options.update(param_key => params[param_key])) if params[param_key]
    end
    options[:q] ? search_all_posts_path(options) : send("posts_path", options)
  end

  def show_image_tag(image_type, image, format = :jpg, image_alt = "italyabroad.com")
    if image.present? && image_type.present? && image.image_filename.present? && image.image_filename.is_a?(ProductUploader)
      return image_tag(image.image_filename.try(:url), image_dimensions(image_type).merge!(:alt => image_alt, :title => image_alt))
    elsif image_type && image && format

      #return image_tag(image_url(image_type, image, format), {:alt => image_alt, :title => image_alt, :height => "80"})
      #"http://localhost:3000/site/image/product_wine/541.jpg"
      #return image_tag(site_image_url(image_type, image, format), {:alt => image_alt, :title => image_alt})
      return image_tag("/resources/images/#{image.id}.#{format}", image_dimensions(image_type).merge!(:alt => image_alt, :title => image_alt))
      #return image_tag("/site/image?id=#{image.id}&image_type=#{image_type}&format=#{format}")
      #return image_tag(url_for(:controller => "site/images", :action => "show", :id => image.id, :format => format))

    elsif image_type
      #return image_tag("no_images/#{image_type}.jpg", :size => "100x120", :alt => image_alt)
      #return image_tag("no_images/#{image_type}.jpg", :alt => image_alt, :width => "80")
      return image_tag("no_images/#{image_type}.jpg", :alt => image_alt).html_safe()
    else
      #return image_tag("no_images/noimage.png", :alt => image_alt, :width => "80")
      return image_tag("no_images/noimage.png", :alt => image_alt).html_safe()
    end
  end

  def thumb_image(product)
    path = '/image/missing.png'
    if product and product.image_1_id
      image= Image.find_by_id(product.image_1_id)
      if image
        logger.info(product.inspect)
        if product.is_landscape
          
            path = image.image_filename.landscape.url
        else
          path = image.image_filename.potrait.url
        end
      end
    
    end
    return path
  end

  def image_dimensions(image_type)
    image_type = image_type.to_sym
    case image_type
      when :product_rec, :region_thumb_small
        {:height => '100', :width => '100'}
      #portrait wine
      # when :wine_category
      #   {:height => '210'}
      # landscap wine
      when :wine_category
        {:height => '112'}
      when :product_food
        {:height => '100'}
      when :wine_category_producers_page, :product_food
        {:height => '133', :width => '100'}
      when :food_category, :food_sub_category, :hamper_sub_category
        {:height => '150', :width => '120'}
      # hampers category portrait
      when :hamper_category, :product_hamper, :product_wine
        {:height => '210'}
      # hampers category landscape
      when :hamper_category, :product_hamper, :product_wine
        {:height => '112'}
      when :wine_sub_category
        {:height => '104', :width => '80'}
      when :grape_thumb, :product_thumb_carta
        {:height => '100', :width => '65'}
      when :avatar_thumb_small 
        {:height => '50', :width => '50'}
      when :avatar_thumb
        {:height => '98', :width => '98'}
      when :home_image, :blog_banner, :about_thumb, :region_card, :original
        {:height => '284', :width => '723'}
      when :home_image_thumb, :category_thumb, :recipe_thumb, :post_thumb, :restaurant_thumb
        {:height => '75', :width => '100'}
      when :category
        {:height => '270', :width => '500'}
      when :product
        {:height => '266px', :width => '200px'} # Change Here
      when :product_wine_tour_left_images
        {:height => '200'}
      when :product_display
        {:height => '600', :width => '800'}
      when :card
        {:height => '80'}
      when :product_hamper_big
        {:height => '120', :width => '120'}
      when :product_food
        {:height => '128', :width => '60'}
      when :product_event
        {:height => '90', :width => '70'}
      when :product_thumb
        {:height => '190', :width => '65'}
      when :product_thumb_cart
        {:height => '30'}
      when :product_show, :producer_thumb, :region_thumb
        {:height => '300', :width => '300'}
      when :product_wine_tour, :wine_tour_category
        {:height => '180', :width => '237'}
      when :post
        {:height => '450', :width => '480'}
      when :restaurant_thumb_site
        {:height => '200', :width => '250'}
      when :recipe, :community_producer_thumb
        {:height => '150', :width => '150'}
      when :blog_view
        {:height => '200', :width => '287'}
      when :product_category
        {:height => '254'}
      when :wine
        {:height => '266px', :width => '200px'}   # change here
      when :mixed_or_food
        {:height => '200px'}   # change here
      when :product_on_discount
        {:height => '200px'}   # change here
      else
        {:width => '95px'}
    end
  end

  def show_image_tag_in_cart(image_type, image, format = :jpg, image_alt = "italyabroad.com")
    if image_type && image && format

      return '<div style="width:100px;height:150px;text-align:center;margin:auto;border-style:solid;border-width:1px;border-color:white;overflow:hidden;v-align:bottom;">' + image_tag(site_image_url(image_type, image, format), {:alt => image_alt, :title => image_alt, :size => "150"}) + '</div>'

    elsif image_type
      return image_tag("no_images/#{image_type}.jpg", :size => "100x120", :alt => image_alt)
    else
      return image_tag("no_images/noimage.png", :alt => image_alt)
    end
  end

  def show_home_image_tag(image, format = :jpg)
    if image && format
      return image_tag("/resources/images/#{image.id}.#{format}", image_dimensions(:original))
      #return image_tag(site_image_url(:original, image, format), :size => "723x284").html_safe()
    else
      return nil
    end
  end

  def nested_products_uri(product)
    return nested_products_path(product.root_category_id, product.sub_category_id, product) if (product && !product.root_category_id.blank? && !product.sub_category_id.blank?)
    return nested_product_path(product.root_category_id, product) if (product && !product.root_category_id.blank? && product.sub_category_id.blank?)
    if (product && product.root_category_id.blank? && !product.sub_category_id.blank? && Category.find(product.categories.first.parent_id).name == "Food")
      return nested_products_path(Category.find_by_name("Food"), product.sub_category_id, product)
    elsif (product && product.root_category_id.blank? && !product.sub_category_id.blank?)
      return nested_products_path(Category.find(product.categories.first.parent_id), product.sub_category_id, product)
    end
    return product_path(product)
  end

  def show_messages(message)
    content_tag(:div, message, :class => "notice" ) unless message.blank?
  end

  def show_ratings(product, score = nil)
    ratings_icon = "ratings_icon.png"
    ratings_icon = "ratings_recipe_icon.png" if product.class.to_s == "Recipe"
    if product.class.to_s != "Recipe" and  product.categories.root
      ratings_icon = "ratings_stars.png" if product.categories.root.name.downcase == "food" or product.categories.root.name.downcase == "hampers"
    end
    return %Q(<span class="ratings" style="#{"background:transparent url(/images/#{ratings_icon}) no-repeat -#{(86 - (product.average_rating.to_f/5.to_f * 86)).round}px center;" if product.average_rating > 0}">&nbsp;</span>) if score.nil?
    return %Q(<span class="ratings" style="#{"background:transparent url(/images/#{ratings_icon}) no-repeat -#{(86 - (score.to_f/5.to_f * 86)).round}px center;"}">&nbsp;</span>)
  end

  def show_review_ratings(product, score = nil)
    ratings_icon = "ratings_icon.png"
    ratings_icon = "ratings_recipe_icon.png" if product.class.to_s == "Recipe"
    if product.class.to_s != "Recipe"
      category_name = product.categories.detect{|category| ["Wine", "Food", "Hampers", "Wine Tours", "Other Drinks"].include?(category.name)}.name
      ratings_icon = "ratings_stars.png" if category_name.downcase == "food" or category_name.downcase == "hampers"
    end
    return %Q(<span class="ratings" style="#{"background:transparent url(/images/#{ratings_icon}) no-repeat -#{(86 - (product.average_rating.to_f/5.to_f * 86)).round}px center;" if product.average_rating > 0}">&nbsp;</span>) if score.nil?
    return %Q(<span class="ratings" style="#{"background:transparent url(/images/#{ratings_icon}) no-repeat -#{(86 - (score.to_f/5.to_f * 86)).round}px center;"}">&nbsp;</span>)
  end

  def site_image_url(image_version, image, format = :jpg)
    image.image_filename.url
  end

  def show_grape_image(grape)
    return image_tag(site_image_path(:grape_original, grape.image, :jpg), :width => "300px") if grape.image
    return image_tag("grape_default.png", :width => "300px")
  end

  def show_region_image(region)
    return image_tag(site_image_url(:region_original, region.image, :jpg), :width => "300px") if region.image
    return image_tag("region-home-image.jpg", :width => "300px")
  end

  def show_producer_image(producer)
    return image_tag(site_image_url(:producer_thumb, producer.image, :jpg), :width => "98px") if producer.image
    return image_tag("default.jpg", :width => "98px")
  end
  def show_producer_image1(producer)
    return image_tag(site_image_url(:producer_thumb, producer.image, :jpg)) if producer.image
    return image_tag("default.jpg", :width => "98px")
  end

  def will_paginate_(object)
    "<table style=\"width:auto;\"><tr><td style=\"width:32px;\"><strong>Page:</strong></td><td>#{will_paginate(object, :previous_label => "&laquo;", :next_label => "&raquo;")}</td></tr></table>" unless will_paginate(object).blank?
  end

  def page_entries_info_(object)
    content_tag(:div, page_entries_info(object), :class => "page_info")
  end

  def check_any_products_remains_for_review(orders)
    show_link = false
    for order in orders
      for order_item in order.order_items
        unless order_item.product_id.nil?
          if order_item.reviewed == false
            show_link = true
          end
        end
      end
    end
    show_link
  end

  def find_any_active_product_exists(products)
    num_products = 0
    for p in products
      num_products = num_products + 1 if p.active == true 
      #and p.product_prices.first.quantity.to_i > 0
    end
    num_products
  end

  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end
      else
        html << "<h5>#{message}</h5>"
      end
      html << "\t\t<ul>\n"
      object.errors.keys.each do |key|
        object.errors[key].each do |value|
          key = "" if key == :base
          html << "\t\t\t<li style='color: red'>#{key} #{value}</li>\n"
        end
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html.html_safe()
  end

  def limited_stock(product)
    if product.out_of_stock? || (product.product_prices.first.try(:quantity).to_i == 0)
      "#{image_tag('out_of_stock.png')}".html_safe
    elsif (quantity = product.product_prices.first.try(:quantity).to_i) <= Product::LIMITED_QUANTITY
      "<b style='color: red'>Quantity: #{quantity} left.</b>".html_safe
    end
  end

end

