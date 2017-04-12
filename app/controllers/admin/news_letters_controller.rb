class Admin::NewsLettersController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @news_letters = NewsLetter.where("").order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    
    respond_to do |format|
      format.html
    end
  end

  def new
    @news_letter = NewsLetter.new
    
    respond_to do |format|
      format.html
    end
  end

  def edit
    @news_letter = NewsLetter.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  def correlation
    @news_letter = NewsLetter.find(params[:id])
    @products = Product.all
    
    respond_to do |format|
      format.html
    end
  end

  def images
    @news_letter = NewsLetter.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  def create
    params[:news_letter][:product_ids] = params[:news_letter][:product_ids].split(",")
    @news_letter = NewsLetter.new(params[:news_letter])
    
    @news_letter.status_news_letter_id =  params[:send] == "1" ? 2 : 1
    
    @news_letter.header.destroy if @news_letter.header && !params["header"].blank?
    @news_letter.build_header(:data => params["header"]) if !params["header"].blank?
        
    8.times do |i|
      @news_letter.send("image_#{i+1}").destroy if @news_letter.send("image_#{i+1}") && !params["image_#{i+1}"].blank?
      @news_letter.send("build_image_#{i+1}", :data => params["image_#{i+1}"]) if !params["image_#{i+1}"].blank?
    end
    
    if @news_letter.save
      redirect_to :action => :index
    else
      @news_letter.header = @news_letter.send("header")
      8.times do |i| 
        tmp = @news_letter.send("image_#{i+1}") 
        tmp = nil 
      end
      flash[:notice] = @news_letter.show_errors
      render :action => :new
    end
    send_news_letter(@news_letter) if params[:send] == "1" && @news_letter.valid?
  end
  
  def send_news_letter(news_letter)
    #For test
    Notifier.news_letter("andrea@italyabroad.com", "D'Ercole", news_letter).deliver
    Notifier.news_letter("adnorty@gmail.com", "Yanto", news_letter).deliver
    
    if news_letter.customers
      for user in User.find(:all, :conditions => ["news_letters=?", true])
        Notifier.news_letter(user.email, user.name.titleize, news_letter).deliver
      end
    end
    
    if news_letter.subscribers
      for subscription in Subscription.find(:all)
        Notifier.news_letter(subscription.email, subscription.name.titleize, news_letter).deliver
      end
    end    
  end

  def update
    params[:news_letter][:product_ids] = params[:news_letter][:product_ids].split(",")
    @news_letter = NewsLetter.find(params[:id])
    
    @news_letter.status_news_letter_id =  params[:send] == "1" ? 2 : 1
    
    @news_letter.header.destroy if @news_letter.header && !params["header"].blank?
    @news_letter.build_header(:data => params["header"]) if !params["header"].blank?
   
    8.times do |i|
      @news_letter.send("image_#{i+1}").destroy if @news_letter.send("image_#{i+1}") && !params["image_#{i+1}"].blank?
      @news_letter.send("build_image_#{i+1}", :data => params["image_#{i+1}"]) if !params["image_#{i+1}"].blank?
    end
   
    if @news_letter.update_attributes(params[:news_letter])
      redirect_to :action => :list
    else
      8.times do |i| 
        tmp = @news_letter.send("image_#{i+1}") 
        tmp = nil
      end
      flash[:notice] = @news_letter.show_errors
      render :action => :edit
    end
 
    send_news_letter(@news_letter) if params[:send] == "1" && @news_letter.valid?
  end

  def destroy
    NewsLetter.find(params[:id]).destroy
    render :update do |page|
      page << "Ext.Msg.alert('Status', 'NewsLetter correctly deleted!');"
    end
  end
  
  def destroy_image
    @news_letter = NewsLetter.find(params[:id])
    
    if params[:img].to_i > 0 && params[:img].to_i <= 8
      @news_letter.send("image_#{params[:img]}").destroy
    end
    
    if params[:img] == "h"
      @news_letter.header.destroy
    end
    
    redirect_to :action => :edit, :id => @news_letter
  end
  
  def data_products
    news_letter = NewsLetter.find_by_id(params[:id])
    products = Product.find(:all) 
    return_data = Hash.new()      
    return_data[:Total] = Product.count      
    return_data[:Products] = products.collect{|u| { :id=>u.id,
                                                    :price => number_to_currency(u.price, :unit => "£"),
                                                    :category => u.root_category,
                                                    :name=>u.name,
                                                    :selected => news_letter.products.include?(u) } }

    render :text=>return_data.to_json, :layout=>false
  end
  
  def data_hampers
    news_letter = NewsLetter.find_by_id(params[:id])
    products = Product.find(:all) 
    return_data = Hash.new()      
    return_data[:Total] = Product.count      
    return_data[:Products] = products.collect{|u| { :id=>u.id,
                                                    :price => number_to_currency(u.price, :unit => "£"),
                                                    :category => u.root_category,
                                                    :name=>u.name,
                                                    :selected => news_letter.hamper == u } }

    render :text=>return_data.to_json, :layout=>false
  end
  
  def data_recipes
    news_letter = NewsLetter.find_by_id(params[:id])
    recipes = Recipe.find(:all) 
    return_data = Hash.new()      
    return_data[:Total] = Product.count      
    return_data[:Recipes] = recipes.collect{|u| { :id=>u.id,
                                                  :name=>u.name,
                                                  :selected => news_letter.recipe == u } }

    render :text=>return_data.to_json, :layout=>false
  end
end

