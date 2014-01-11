class ApplicationController < ActionController::Base
  include ApplicationHelper
  include AuthenticatedSystem
  include PdfHelper
  include SslRequirement
  include SimpleCaptcha::ControllerHelpers

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :redirect_to_new_url, :instantiate_controller_and_action_names, :find_or_initialize_cart, :initialize_general_variable

  rescue_from ActiveRecord::RecordNotFound, :with => :render_record_not_found
  rescue_from ActiveRecord::RecordInvalid, :with => :render_record_not_found
  rescue_from ActionController::RoutingError, :with => :render_record_not_found
  rescue_from ActionController::UnknownController, :with => :render_record_not_found
  rescue_from ActionController::UnknownAction, :with => :render_record_not_found
  rescue_from ActionController::MethodNotAllowed, :with => :render_record_not_found
  rescue_from ActionController::MethodNotAllowed, :with => :render_record_not_found
 # rescue_from Exception, :with => :render_record_not_found


  protected
  def active
    {
      :find   => {:conditions => ["active = ?", true]}
    }
  end



  def render_record_not_found
    flash[:notice] = "Error cannot proceed"
   # logger.info {"#{@current_controller}" }
    #logger.info "Exception, redirecting: #{exception.message}" if exception
    redirect_to root_url
 end


  private
  def find_or_initialize_cart
    @cart = session[:cart] ||= Cart.new
  end

  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
    @page_id = "#{@current_controller}_#{@current_action}"
  end

  def xml
  end

  def redirect_to_new_url
    if params[:old_url]
      headers["Status"] = "301 Moved Permanently"
      redirect_to(:action => action_name)
    end
  end

  def initialize_general_variable
    @setting = Setting.first
  end
end
