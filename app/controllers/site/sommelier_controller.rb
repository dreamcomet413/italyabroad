class Site::SommelierController < ApplicationController

  layout "site"

  def index
    session[:selected_search_options] = {} unless (params[:st].present? || params[:rt].present?)
    @questions = [
        "Which wine would you like to drink?",
        "Light, medium or full bodied?",
        "To accompany food or to drink on its own?",
        "How much would you like to spend?",
        "What food is the wine for?"
    ]
  end

  def create

    session[:selected_search_options] ||= {}

    @questions = [
        "Which wine would you like to drink?",
        "Light, medium or full bodied?",
        "To accompany food or to drink on its own?",
        "How much would you like to spend?",
        "What food is the wine for?"
    ]

    session[:selected_search_options][:wine_type] = params[:selected_option] if ["Red Wine", "Rose Wine", "White Wine", "Sparkling Wine", "Surprise Me"].include?(params[:selected_option])
    session[:selected_search_options][:body_type] = params[:selected_option] if ["Light", "Medium", "Full Body"].include?(params[:selected_option])
    session[:selected_search_options][:price_type] = params[:selected_option].to_s.gsub("£", "") if ["under £10", "between £10 and £20", "more than £20"].include?(params[:selected_option])
    session[:selected_search_options][:food_type] = params[:selected_option] if ["red meat", "white meat", "pasta", "fish", "cheeses", "desserts"].include?(params[:selected_option])
    session[:selected_search_options][:choice] = params[:selected_option] if ["drink on its own","with food"].include?(params[:selected_option])

    cookies[:selected_wine] = session[:selected_search_options][:wine_type] if ["Red Wine", "Rose Wine", "White Wine", "Sparkling Wine", "Surprise Me"].include?(params[:selected_option])
    logger.info(cookies[:selected_wine])  
    logger.info('===============================================================')

    if params[:selected_option] == "Sparkling Wine"
      params[:step] = "2"
    end
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
      format.html {}
      format.js {
        render :update do |page|
          if search_options.present?
            sleep(2)
            session[:selected_search_options][:wine_type] = params[:selected_option] if ["Red Wine", "Rose Wine", "White Wine", "Sparkling Wine", "Surprise Me"].include?(params[:selected_option])
            session[:selected_search_options][:body_type] = params[:selected_option] if ["Light", "Medium", "Full Body"].include?(params[:selected_option])
            session[:selected_search_options][:price_type] = params[:selected_option].to_s.gsub("£", "") if ["under £10", "between £10 and £20", "more than £20"].include?(params[:selected_option])
            session[:selected_search_options][:food_type] = params[:selected_option] if ["red meat", "white meat", "pasta", "fish", "cheeses", "desserts"].include?(params[:selected_option])
            page[".items"].html("")
            page[".items"].html(render :partial => "search_options", :locals => {:item_options => search_options, :step => (params[:step].to_i + 1).to_s})
          else
            page.redirect_to search_index_path(price_type: session[:selected_search_options][:price_type] , wine_type: cookies[:selected_wine] , parent_type: 'wine')
          end
        end
      }
    end
  end
end 
