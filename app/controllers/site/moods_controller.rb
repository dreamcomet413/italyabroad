class Site::MoodsController < ApplicationController

  layout "site"

  def index
    @moods = Mood.all
  end

end
