class Admin::XmlController < ApplicationController

  before_filter :admin_login_required
  layout "admin"

  def index
    @count = 1
    @tables = ["Category",  "Comment",
       "Grape", "Newsletters subscribers","Order",
      "Producer",  "Product", "ProductsGrape",
      "Recipe", "Region", "Resource", "Review",
       "StatusOrder", "Subscription",  "User"]

  end


  def xml_options
    if params[:table] != 'Category'
      @columns = eval(params[:table]).column_names
    else
      @columns = eval(params[:table]).column_names
    end
    respond_to do |format|
      format.html{ render :update do |page|
          if params[:type] == 'Newsletters subscribers'
            page.replace_html "options#{params[:count]}" , :partial => "xml_options", :locals => {:columns => @columns,
              :table => params[:table], :id => params[:id], :type => params[:type]}
            page.visual_effect :highlight, "options#{params[:count]}"
          else
            page.replace_html "options#{params[:count]}" , :partial => "xml_options", :locals => {:columns => @columns,
              :table => params[:table], :id => params[:id]}
            page.visual_effect :highlight, "options#{params[:count]}"
          end
        end
      }
    end
  end

  def eval_xml
    @dataset = []
    # @data = eval(params[:table]).all
    if params[:table] == 'Category'
      @root = Category.find(params[:id])
      @dataset= @root.children
      @dataset.each do |data|
           data[:condition] = "new"
      end
      @xml = @dataset.to_xml(:skip_types => true, :camelize => true, :skip_instruct => true,
        :only => params[:names]).gsub('nil="true"',"").gsub("\n","")
      File.open("#{@root.name}.xml", 'w') {|f| f.write(@xml) }
      send_file File.join(Rails.root,"#{@root.name}.xml" ), :type => "xml"

    elsif params[:table] == 'Product'
     # @new_data = []
     item_string = ""
     whole_product = ""
      header_string = '<?xml version="1.0" encoding="UTF-8" ?>'
      header_string += '<rss version ="2.0" xmlns:g="http://base.google.com/ns/1.0">'
      header_string += '<channel>'
      header_string += '<title>Products Data</title>'
      header_string += '<link>http://www.example.com</link>'
      footer_string = '</channel>'
      footer_string +='</rss>'

      @data = eval(params[:table]).find(:all, :conditions =>["active = ?", 1])
      @data.each do |data|

       item_string += '<item>'
      item_string += '<g:id>'+ data.id.to_s + '</g:id>'
      item_string += '<title>Title</title>'
      item_string += '<g:condition>new</g:condition>'
      item_string += '<g:quantity>'+ data.quantity.to_s + '</g:quantity>'
      item_string += '<name>'+ h(data.name) + '</name>'
      item_string += '<description>'+ h(data.description) + '</description>'

     item_string += '<link>' + h(url_for(:only_path => false, :controller => "site/products", :action => "show", :id =>"#{data.friendly_identifier}"))  + '</link>'
      item_string += '<g:price>'+ data.price.to_s + '</g:price>'
      item_string += '<rate>'+ data.rate.to_s + '</rate>'
      item_string += '</item>'

      #    p_name = (data.name).downcase.split(" ").map{|w| w.gsub(/[^\._\-a-z0-9\@]/i,'')}.join("-") if data.name
      #    data[:link] = "http://italyabroad.ejubel.com/#{data.unique_categories.collect {|c|c.name.downcase.split(" ").map{|w| w.gsub(/[^\._\-a-z0-9\@]/i,'')}.join("-")}.join("/")}/#{(p_name)}" if data.unique_categories
   #       data[:condition] = "new"
     end

      whole_product = header_string + item_string + footer_string


# the follwoing block already commented before making any change -----------------------------------

            #      render :text => '<pre>'+@data.to_yaml and return
            #      for data in Product.find(:all)
            #        @data << "http://localhost:3000/#{data.unique_categories.collect {|c|c.name}.join("/")}/#{data.name}" if data.unique_categories
            #
            #      end

# already commented block before making any change ends here--------------------------


   #   p"*********************"
   #   p @data
   #   p YAML::dump(@data.length)
  #  @xml = @data.to_xml(:skip_types => true, :camelize => true, :skip_instruct => true,
     #   :only => params[:names]).gsub('nil="true"',"").gsub("\n","")



  # already commented before making any change by legreens
          #      render :text => '<pre>'+@xml.to_yaml and return
  # already commented before making any change by legreens ends here



    #  File.open("#{params[:table]}.xml", 'w') {|f| f.write(@xml) }

     File.open("#{params[:table]}.xml", 'w') {|f| f.write(whole_product) }

      send_file File.join(Rails.root,"#{params[:table]}.xml" ), :type => "xml"

      elsif params[:type] == 'Newsletters subscribers'
      @data = eval(params[:table]).find(:all, :conditions =>["news_letters = ?", 1])

      @data.each do |data|
           data[:condition] = "new"
      end

      p YAML::dump(@data.length)
      @xml = @data.to_xml(:skip_types => true, :camelize => true, :skip_instruct => true,
        :only => params[:names]).gsub('nil="true"',"").gsub("\n","")
      File.open("#{params[:type]}.xml", 'w') {|f| f.write(@xml) }
      send_file File.join(Rails.root,"#{params[:type]}.xml" ), :type => "xml"

    else
      @data = eval(params[:table]).all
      @data.each do |data|
           data[:condition] = "new"
      end
      @xml = @data.to_xml(:skip_types => true, :camelize => true, :skip_instruct => true,
        :only => params[:names]).gsub('nil="true"',"").gsub("\n","")
      File.open("#{params[:table]}.xml", 'w') {|f| f.write(@xml) }
      send_file File.join(Rails.root,"#{params[:table]}.xml" ), :type => "xml"
    end

  end

end

