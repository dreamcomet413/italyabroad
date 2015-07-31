class Site::SommelierController < ApplicationController

  layout "site"

  def index
    session[:selected_search_options] = {}
    @questions = [
        "Which wine would you like to drink?",
        "Light, medium or full bodied?",
        "To accompany food or to drink on its own?",
        "How much would you like to spend?",
        "What type of food is the wine for?"
    ]
  end

  def create
    session[:category] = Category.find(params[:selected_option].gsub(" ", "-").downcase.pluralize) if params[:step] == "1"

    @questions = [
        "Which wine would you like to drink?",
        "Light, medium or full bodied?",
        "To accompany food or to drink on its own?",
        "How much would you like to spend?",
        "What type of food is the wine for?"
    ]
    session[:search_text] = params[:selected_option] if params[:step] == "1"

    session[:selected_search_options][:wine_type] = params[:selected_option]  if ["Red Wine", "Rose Wine", "White Wine", "Sparkling Wine", "Surprise Me"].include?(params[:selected_option])
    session[:selected_search_options][:body_type] = params[:selected_option]  if ["Light", "Medium", "Full Body"].include?(params[:selected_option])
    session[:selected_search_options][:price_type] = params[:selected_option].gsub("£","")  if ["under £10", "between £10 and £20", "more than £20"].include?(params[:selected_option])
    session[:selected_search_options][:food_type] = params[:selected_option]  if ["red meat", "white meat", "pasta", "fish", "cheeses", "desserts"].include?(params[:selected_option])


    search_options =
        case params[:step]
          when "1"
            ["Light", "Medium", "Full Body"]
          when "2"
            ["drink on its own", "with food"]
          when "3"
            if params[:selected_option] == "with food"
              ["red meat", "white meat", "pasta", "fish", "cheeses", "desserts"]
            else
              ["under £10", "between £10 and £20", "more than £20"]
            end
          when "4"
            ["under £10", "between £10 and £20", "more than £20"] if ["red meat", "white meat", "pasta", "fish", "cheeses", "desserts"].include?(params[:selected_option])
        end

    respond_to do |format|
      format.html{}
      format.js {
        render :update do |page|
          if search_options.present?
            page[".items"].html("")
            page[".items"].html(render :partial => "search_options", :locals => {:item_options => search_options, :step => (params[:step].to_i + 1).to_s, :category => session[:category]})
          else
            page.redirect_to search_index_url(session[:selected_search_options])
          end
        end
      }
    end
  end
end
