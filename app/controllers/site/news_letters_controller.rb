class Site::NewsLettersController < ApplicationController
  def show
    @news_letter = NewsLetter.find(params[:id])
    render :layout => false
  end
end
