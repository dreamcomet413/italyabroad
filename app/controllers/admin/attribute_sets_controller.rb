class Admin::AttributeSetsController < ApplicationController
  before_filter :admin_login_required
  
  def index
    render :layout => false
  end
  
  def new
    @attribute_set = AttributeSet.new
    @attribute_items = AttributeItem.find(:all, :order => :name)
    render :layout => false
  end
  
  def edit
    @attribute_set = AttributeSet.find(params[:id])
    @attribute_items = AttributeItem.find(:all, :order => :name)
    render :layout => false
  end
  
  def create
    params[:attribute_set][:attribute_item_ids] ||= []
    
    @attribute_set = AttributeSet.new(params[:attribute_set])
    @attribute_items = AttributeItem.find(:all, :order => :name)
    
    if @attribute_set.save
      status = "Attribute Set succefully created!"
    else
      status = "There are some problems, please check the fields"
    end
    
    render :update do |page|
      page.replace_html("form-attribute-sets", :partial => "form")
      page << "Ext.Msg.alert('Status', '#{status}');"
    end
  end
  
  def update
    params[:attribute_set][:attribute_item_ids] ||= []
    
    @attribute_set = AttributeSet.find(params[:id])
    @attribute_items = AttributeItem.find(:all, :order => :name)
    
    if @attribute_set.update_attributes(params[:attribute_set])
      status = "Attribute Set succefully updated!"
    else
      status = "There are some problems, please check the fields"
    end
    
    render :update do |page|
      page.replace_html("form-attribute-sets", :partial => "form")
      page << "Ext.Msg.alert('Status', '#{status}');"
    end
  end
  
  def destroy
    AttributeSet.find(params[:id]).destroy
    render :update do |page|
      page << "Ext.Msg.alert('Status', 'Attribute Set correctly deleted!');"
    end
  end
  
  def data
    start = (params[:start] || 1).to_i      
    size = (params[:limit] || 20).to_i 
    sort_col = (params[:sort] || 'id')
    sort_dir = (params[:dir] || 'ASC')

    page = ((start/size).to_i)+1

    @pages = Paginator.new(self, AttributeSet.count(), size, page)    

    @attribute_sets = AttributeSet.find(:all, :limit=>@pages.items_per_page,
                               :offset=>@pages.current.offset,
                               :order=>sort_col+' '+sort_dir)

    return_data = Hash.new()      
    return_data[:Total] = @pages.item_count      
    return_data[:AttributeSets] = @attribute_sets.collect{|u| {:id=>u.id, 
                                                               :name=>u.name } }
                                                
    render :text=>return_data.to_json, :layout=>false
  end
end
