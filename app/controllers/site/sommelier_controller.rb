class Site::SommelierController < ApplicationController

  layout "site"

  def index

  end

  def create
    search_options =
        case params[:step]
          when "1"
            ["Light", "Medium", "Full Body"]
        end
    respond_to do |format|
      format.html{}
      format.js {
      render :update do |page|
        #if params[:step] == "1"
        #end
      end
      }
    end
  end

  def new
  end
end
