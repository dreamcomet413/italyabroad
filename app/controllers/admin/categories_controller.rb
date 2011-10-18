class Admin::CategoriesController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    categories = Category.find_by_sql("select * from categories where parent_id is null")
    @data = get_tree(categories,nil)
  end

  def new
    @category = Category.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @category = Category.new(params[:category])
    if  @category.valid? and !params[:image].nil?
      @image = Image.new(params[:image])
      @image.save
      @category.image_id = @image.id
      @category.image_url = params[:image][:image_file]
    end
    if @category.save
      unless params[:category][:parent_id].blank?
       @category.move_to_child_of(params[:category][:parent_id])
      end
      flash[:notice] = "Category is created successfully"
      redirect_to :action => :index
    else
      flash[:notice] = "There are something wrong"
      render :action => :new
    end
  end

  def edit
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def update
    @category = Category.find(params[:id])

    if @category.valid? and  !params[:image].nil?
      @category.image.destroy unless @category.image.nil?
      @image = Image.new(params[:image])
      @image.save
      @category.image_id = @image.id
      @category.image_url = params[:image][:image_file]
     end
    if @category.update_attributes(params[:category])
      unless params[:category][:parent_id].blank?
         @category.move_to_child_of(params[:category][:parent_id])
      end
      flash[:notice] = "Category is updated successfully"
    else
      flash[:notice] = "There are something wrong"
    end

    render :action => :edit
  end

  def makeChildren(id, categories, root, temps, temps_categorizations)
    children = []

    for category in categories
      children << category if category["parent_id"] == id
    end

    for child in children
      tmp = nil
      temps.each { |q| tmp = q if q.id == child["id"] }

      attributes = Hash.new
      categorizations = []

      if tmp
        attributes = tmp.attributes
        temps_categorizations.each { |p| categorizations << p if p.category_id == tmp.id}
        tmp.id = nil
      end

      attributes.merge!({:name => child["text"]})
      t = Category.create(attributes)
      categorizations.each { |p| Categorization.create({:category_id => t.id, :product_id => p.product_id}) }

      root.add_child(t)
      categories.delete child

      makeChildren(child["id"], categories, t, temps, temps_categorizations)
    end
  end

  def load_details
    if params[:id].to_i > 0
      @category = Category.find_by_id(params[:id])
    end

    render :update do |page|
      page.replace_html("form", :partial => "form")
    end
  end

  def update_details
    @category = Category.find_by_id(params[:id])

    @category.image.destroy if @category.image && !params[:uploaded_data].blank?
    @category.build_image(:data => params[:uploaded_data]) unless params[:uploaded_data].blank?

    if @category.update_attributes(params[:category])
      flash[:notice] = "Save completed!"
    else
      flash[:notice] = "Save failed! Please check the field!"
    end

    respond_to_parent do
      render :update do |page|
        page << "Ext.Msg.alert('Status', '#{flash[:notice]}');"
        page << "EditableCategories.refresh(#{@category.id});"
        ##page.replace_html("form-categories", :partial => "form") Not work, create some problem with safari... Don't kwnow why
      end
    end
  end

  def roots
    @categories = Category.find(:all, :conditions => ["parent_id IS ?", nil])
    return_data = Hash.new()
    return_data[:Categories] = @categories.collect{|u| {:id=>u.id, :name=>u.name } }
    render :text=>return_data.to_json, :layout=>false
  end

  def get_tree(categories, parent)
    data = Array.new
    categories.each { |category|
      if !category.leaf?
        if data.empty?
          data =   [{"text"  =>  category.name, "id"  => category.id, "leaf"  => false,
                     "children" => get_tree(category.children,category) }]
        else
          data.concat([{"text"  =>  category.name, "id"  => category.id, "leaf"  => false,
                         "children" => get_tree(category.children,category)}])
        end
      else
        data.concat([{"text" => category.name, "id" => category.id, "cls" => "folder", "leaf" => false, "children" => []}])
      end
    }
    return data
  end

  def destroy
    Category.find_by_id(params[:id]).destroy
    redirect_to :action => :index
  end

end

