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
      @new_data = []
      @data = eval(params[:table]).find(:all, :conditions =>["active = ?", 1])
      @data.each do |data|
          p_name = (data.name).downcase.split(" ").map{|w| w.gsub(/[^\._\-a-z0-9\@]/i,'')}.join("-") if data.name
          data[:link] = "http://italyabroad.ejubel.com/#{data.unique_categories.collect {|c|c.name.downcase.split(" ").map{|w| w.gsub(/[^\._\-a-z0-9\@]/i,'')}.join("-")}.join("/")}/#{(p_name)}" if data.unique_categories
          data[:condition] = "new"
      end
#      render :text => '<pre>'+@data.to_yaml and return
#      for data in Product.find(:all)
#        @data << "http://localhost:3000/#{data.unique_categories.collect {|c|c.name}.join("/")}/#{data.name}" if data.unique_categories
#
#      end
      p"*********************"
      p @data
      p YAML::dump(@data.length)
      @xml = @data.to_xml(:skip_types => true, :camelize => true, :skip_instruct => true,
        :only => params[:names]).gsub('nil="true"',"").gsub("\n","")
#      render :text => '<pre>'+@xml.to_yaml and return
      File.open("#{params[:table]}.xml", 'w') {|f| f.write(@xml) }
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

