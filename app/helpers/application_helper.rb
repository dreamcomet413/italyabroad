# nasty hack used to handle new category routes
module ApplicationHelper

  def avatar_for_user(user, size="big")
    image = (size=="big") ? "default_big.jpg" : "default.jpg"
    unless user.nil?
      if user.has_default_photo?
        image = user.get_photo_default(size)
      elsif user.has_photo?
        if size=="big"
          image = image_url("avatar_thumb", user.photo, :jpg)
        else
          image = image_url("avatar_thumb_small", user.photo, :jpg)
        end
      end
    end
    content_tag(:div, image_tag(image), :class => "user_photo_#{size}", :id => "user_photo")
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
    options = user.ship_addresses.inject([["Use Default",0]]) { |options, s| options << [s.code, s.id] }
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

  def truncate_words(text, length = 30, end_string = ' …')
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
    if image_type && image && format

        return image_tag(image_url(image_type, image, format), {:alt => image_alt, :title => image_alt})

    elsif image_type
      return image_tag("no_images/#{image_type}.jpg", :size => "100x120", :alt => image_alt)
    else
      return image_tag("no_images/noimage.png", :alt => image_alt)
    end
  end

  def show_home_image_tag(image, format = :jpg)
    if image && format
      return image_tag(image_url(:original, image, format), :size => "723x284")
    else
      return nil
    end
  end

  def nested_products_uri(product)
    return nested_products_path(product.root_category_id, product.sub_category_id, product) if (product && !product.root_category_id.blank? && !product.sub_category_id.blank?)
    return nested_product_path(product.root_category_id, product) if (product && !product.root_category_id.blank? && product.sub_category_id.blank?)
    return product_path(product)
  end

  def show_messages(message)
   content_tag(:div, message, :class => "notice") unless message.blank?
  end

  def show_ratings(product, score = nil)
    ratings_icon = "ratings_icon.png"
    ratings_icon = "ratings_recipe_icon.png" if product.class.to_s == "Recipe"
    ratings_icon = "ratings_stars.png" if product.categories.root.name.downcase == "food" or product.categories.root.name.downcase == "hampers"
    return %Q(<span class="ratings" style="#{"background:transparent url(/images/#{ratings_icon}) no-repeat -#{(86 - (product.average_rating.to_f/5.to_f * 86)).round}px center;" if product.average_rating > 0}">&nbsp;</span>) if score.nil?
    return %Q(<span class="ratings" style="#{"background:transparent url(/images/#{ratings_icon}) no-repeat -#{(86 - (score.to_f/5.to_f * 86)).round}px center;"}">&nbsp;</span>)
  end

  def show_review_ratings(product, score = nil)
   ratings_icon = "ratings_icon.png"
    ratings_icon = "ratings_recipe_icon.png" if product.class.to_s == "Recipe"
    if product.class.to_s != "Recipe"
    ratings_icon = "ratings_stars.png" if product.categories.root.name.downcase == "food" or product.categories.root.name.downcase == "hampers"
  end
    return %Q(<span class="ratings" style="#{"background:transparent url(/images/#{ratings_icon}) no-repeat -#{(86 - (product.average_rating.to_f/5.to_f * 86)).round}px center;" if product.average_rating > 0}">&nbsp;</span>) if score.nil?
    return %Q(<span class="ratings" style="#{"background:transparent url(/images/#{ratings_icon}) no-repeat -#{(86 - (score.to_f/5.to_f * 86)).round}px center;"}">&nbsp;</span>)
  end


  def show_grape_image(grape)
    return image_tag(image_url(:grape_thumb, grape.image, :jpg)) if grape.image
    return image_tag("grape_default.png")
  end

  def show_region_image(region)
    return image_tag(image_url(:region_thumb, region.image, :jpg),:size => "100x120") if region.image
    return image_tag("region-home-image.jpg",:size => "100x120")
   # return image_tag("region_default.png",:size => "100x120")
  end
   def show_producer_image(producer)
    return image_tag(image_url(:producer_thumb, producer.image, :jpg),:size => "100x120") if producer.image
   # return image_tag("region_default.png",:size => "100x120")
   return image_tag("producer_default.png",:size => "100x120")
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

end

