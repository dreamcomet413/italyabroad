require "juggernaut"

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include AuthenticatedSystem
  include PdfHelper
#  include SslRequirement
  include SimpleCaptcha::ControllerHelpers

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :check_if_cookie_exists, :except => :sitemap
  before_filter :redirect_to_new_url, :instantiate_controller_and_action_names, :find_or_initialize_cart, :initialize_general_variable

  if Rails.env == 'production' 
    rescue_from ActiveRecord::RecordNotFound, :with => :render_record_not_found
    rescue_from ActiveRecord::RecordInvalid, :with => :render_record_not_found
    rescue_from ActionController::RoutingError, :with => :render_record_not_found
    rescue_from ActionController::UnknownController, :with => :render_record_not_found
    rescue_from ActionController::UnknownAction, :with => :render_record_not_found
    rescue_from ActionController::MethodNotAllowed, :with => :render_record_not_found
    rescue_from ActionController::MethodNotAllowed, :with => :render_record_not_found
  end
 # rescue_from Exception, :with => :render_record_not_found

  def send_message
    render_text "<li>" + params[:msg_body] + "</li>"
    Juggernaut.publish("/site/chat", parse_chat_message(params[:msg_body], "Prabhat"))
  end

  def parse_chat_message(msg, user)
    return "#{user} says: #{msg}"
  end

  #def default_url_options(options={})
  #  https =  { :protocol => "https" }
  #  options.merge https
  #end


  protected

    def switch_session
      session[:previous_admin_id] = current_user.id
      self.current_user = @user
      session[:user_id] = @user.id
      session[:ship_address]=nil
    end

    def revert_session
      # is signed by admin as customer then restore admin account after order complete
      if(session[:previous_admin_id])
        self.current_user = User.find(session[:previous_admin_id])
        session[:user_id]=session[:previous_admin_id]
        session[:previous_admin_id] = nil
      end
    end

    
  def active
    {
      :find   => {:conditions => ["active = ?", true]}
    }
  end



  def render_record_not_found
    flash[:notice] = "Error cannot proceed"
   # logger.info {"#{@current_controller}" }
    #logger.info "Exception, redirecting: #{exception.message}" if exception
    redirect_to '/404'
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
  def check_if_cookie_exists
    if !cookies[:existing_user] and params[:controller] == "site/base" and params[:action]="index"
      cookies[:existing_user] = true
      session[:return_path] = request.fullpath
      redirect_to '/landing.html'
    end
  end
  def initialize_general_variable
    @setting = Setting.first
  end
end
