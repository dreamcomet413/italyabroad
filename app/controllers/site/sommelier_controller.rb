class Site::SommelierController < ApplicationController

  layout "site"

  def index
    @questions = [
        "Which wine would you like to drink?",
        "Light, medium or full bodied?",
        "To accompany food or to drink on its own?",
        "How much would you like to spend?",
        "What type of food is the wine for?"
    ]
  end

  def create
    @questions = [
        "Which wine would you like to drink?",
        "Light, medium or full bodied?",
        "To accompany food or to drink on its own?",
        "How much would you like to spend?",
        "What type of food is the wine for?"
    ]
    session[:search_text] = params[:selected_option] if params[:step] == "1"
    search_options =
        case params[:step]
          when "1"
            ["Light", "Medium", "Full Body"]
          when "2"
            ["drink on its own", "with food"]
          when "3"
            if params[:selected_option] == "with food"
              ["Red Meat", "White Meat", "Pasta", "Fish", "Cheeses", "Desserts"]
            else
              ["under £10", "between £10 and £15", "more than £15"]
            end
          when "4"
            ["under £10", "between £10 and £15", "more than £15"] if ["Red Meat", "White Meat", "Pasta", "Fish", "Cheeses", "Desserts"].include?(params[:selected_option])
        end
    respond_to do |format|
      format.html{}
      format.js {
        render :update do |page|
          if search_options.present?
            page[".items"].html("")
            page[".items"].html(render :partial => "search_options", :locals => {:item_options => search_options, :step => (params[:step].to_i + 1).to_s})
          else
            page.redirect_to("/search?text=#{session[:search_text]}&id=wine")
          end
        end
      }
    end
  end
end
