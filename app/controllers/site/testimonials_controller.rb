class Site::TestimonialsController < ApplicationController
   layout "site"
   def index
    @testimonials = Testimonial.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @testimonials }
    end
  end
end

