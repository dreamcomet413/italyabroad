url = "https://www.italyabroad.com"
xml.urlset(:xmlns=>"http://www.sitemaps.org/schemas/sitemap/0.9", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation"=>"http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd") do 
	xml.url do
	    xml.loc         "#{url}"
	    xml.lastmod     w3c_date(Time.now)
	    xml.changefreq  "always"
	end
	
	Category.where(:parent_id=>nil).each do |category|
	    
      xml.url do
	      xml.loc         "#{url}/#{category.friendly_identifier}"
	      xml.lastmod     w3c_date(Time.now)
	      xml.changefreq  "weekly"
        xml.priority    0.6

	    end
      
      if category.categories.count == 0
        category.products.each do |product|
          
          if product.active
            # for events only show future events
            if category.friendly_identifier != 'events' or (product.date and product.date>Time.now)
              xml.url do
                xml.loc         "#{url}/#{category.friendly_identifier}/#{product.friendly_identifier}"
                xml.lastmod     w3c_date(Time.now)
                xml.changefreq  "daily"
                xml.priority    0.8
              end
            end
          end          
        end
      end


      category.categories.each do |subcategory|

        xml.url do
          xml.loc         "#{url}/#{category.friendly_identifier}/#{subcategory.friendly_identifier}"
          xml.lastmod     w3c_date(Time.now)
          xml.changefreq  "weekly"
          xml.priority    0.6

        end

        subcategory.products.each do |product|
          if product.active
            xml.url do
              xml.loc         "#{url}/#{category.friendly_identifier}/#{subcategory.friendly_identifier}/#{product.friendly_identifier}"
              xml.lastmod     w3c_date(Time.now)
              xml.changefreq  "daily"
              xml.priority    0.8
            end          
          end
        end
      end
	end

  # Community
  xml.url do
    xml.loc         "#{url}/wine-community"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "daily"
    xml.priority    0.6
  end

  # Members
  User.last(12).each do |customer|
    xml.url do
      xml.loc         "#{url}/customers/id"
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "weekly"
      xml.priority    0.6
    end
  end


  # grape guide
  
  xml.url do
    xml.loc         "#{url}/grape-guide"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  Grape.all.each do |grape|
    xml.url do
      xml.loc         "#{url}/grapes/#{grape.friendly_identifier}"
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "weekly"
      xml.priority    0.6
    end
  end

  # Q & A
  xml.url do
    xml.loc         "#{url}/faqs"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  #Producers
  xml.url do
    xml.loc         "#{url}/producers"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  Producer.where(:active=>true).each do |producer|
    xml.url do
      xml.loc         "#{url}/producers/#{producer.friendly_identifier}"
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "weekly"
      xml.priority    0.6
    end
  end

  #Regions
  xml.url do
    xml.loc         "#{url}/regions"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  Region.where(:active=>true).each do |region|
    xml.url do
      xml.loc         "#{url}/regions/#{region.friendly_identifier}"
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "weekly"
      xml.priority    0.6
    end
  end

  #Recipes
  xml.url do
    xml.loc         "#{url}/recipes"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  Recipe.where(:active=>true).each do |recipe|
    xml.url do
      xml.loc         "#{url}/recipes/#{recipe.friendly_identifier}"
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "weekly"
      xml.priority    0.6
    end
  end

  # Blogs
  Post.all.each do |post|
    post.save unless post.friendly_identifier # create friendly identifier if it is null, because some were null in db
    
    xml.url do
      xml.loc         "#{url}/blog/#{post.friendly_identifier}"
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "daily"
      xml.priority    0.6
    end

  end


  # testimonials
  xml.url do
    xml.loc         "#{url}/testimonials"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  # About us pages
  xml.url do
    xml.loc         "#{url}/about-us/our-principles"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/about-us"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/about-us/meet-us"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/about-us/contact-us"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/about-us/wholesale-enquiry"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/about-us/corporate-services"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/supplier"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/guarantee-of-satisfaction"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/wine/gift-cards"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  # Help pages
  xml.url do
    xml.loc         "#{url}/help/terms-and-conditions"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/help/privacy-policy"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/help/delivery-services"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/help/contact-details"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{url}/sitemap"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end



  # news letter subscribe
  xml.url do
    xml.loc         "#{url}/subscribe-dali-news"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end


end