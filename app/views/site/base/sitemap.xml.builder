site_url = "http://www.italyabroad.com"
xml.urlset(:xmlns=>"http://www.sitemaps.org/schemas/sitemap/0.9", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation"=>"http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd") do 
	xml.url do
	    xml.loc         "#{site_url}"
	    xml.lastmod     w3c_date(Time.now)
	    xml.changefreq  "always"
	end
	
	Category.where(:parent_id=>nil).each do |category|
	    
      xml.url do
	      xml.loc         "#{site_url}/#{category.friendly_identifier}"
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
                xml.loc         "#{site_url}/#{category.friendly_identifier}/#{product.friendly_identifier}"
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
          xml.loc         "#{site_url}/#{category.friendly_identifier}/#{subcategory.friendly_identifier}"
          xml.lastmod     w3c_date(Time.now)
          xml.changefreq  "weekly"
          xml.priority    0.6

        end

        subcategory.products.each do |product|
          if product.active
            xml.url do
              xml.loc         "#{site_url}/#{category.friendly_identifier}/#{subcategory.friendly_identifier}/#{product.friendly_identifier}"
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
    xml.loc         "#{site_url}/wine-community"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "daily"
    xml.priority    0.6
  end

  # Members
  User.last(12).each do |customer|
    xml.url do
      xml.loc         "#{site_url}/site/customers/id"
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "weekly"
      xml.priority    0.6
    end
  end


  # grape guide
  
  xml.url do
    xml.loc         "#{site_url}/grape-guide"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  Grape.all.each do |grape|
    xml.url do
      xml.loc         "#{site_url}/site/grapes/#{grape.friendly_identifier}"
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "weekly"
      xml.priority    0.6
    end
  end

  # Q & A
  xml.url do
    xml.loc         "#{site_url}/site/faqs"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  #Producers
  xml.url do
    xml.loc         "#{site_url}/site/producers"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  Producer.all.each do |producer|
    xml.url do
      xml.loc         "#{site_url}/site/producers/#{producer.friendly_identifier}"
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "weekly"
      xml.priority    0.6
    end
  end

  #Regions
  xml.url do
    xml.loc         "#{site_url}/site/regions"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  Region.all.each do |region|
    xml.url do
      xml.loc         "#{site_url}/site/regions/#{region.friendly_identifier}"
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "weekly"
      xml.priority    0.6
    end
  end

  # Blogs
  Post.all.each do |post|
    post.save unless post.friendly_identifier # create friendly identifier if it is null, because some were null in db
    
    xml.url do
      xml.loc         "#{site_url}/site/blog/#{post.friendly_identifier}"
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "daily"
      xml.priority    0.6
    end

  end


  # testimonials
  xml.url do
    xml.loc         "#{site_url}/testimonials"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  # About us pages
  xml.url do
    xml.loc         "#{site_url}/about-us/our-principles"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/about-us"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/about-us/meet-us"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/about-us/contact-us"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/about-us/wholesale-enquiry"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/about-us/corporate-services"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/supplier"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/guarantee-of-satisfaction"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/wine/gift-cards"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  # Help pages
  xml.url do
    xml.loc         "#{site_url}/help/terms-and-conditions"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/help/privacy-policy"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/help/delivery-services"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/help/contact-details"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end

  xml.url do
    xml.loc         "#{site_url}/sitemap"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end



  # news letter subscribe
  xml.url do
    xml.loc         "#{site_url}/subscribe-dali-news"
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
    xml.priority    0.6
  end


end