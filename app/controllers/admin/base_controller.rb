class Admin::BaseController < ApplicationController
  before_filter :admin_login_required, :except => [:login]
  layout "admin"

  def index
  end
  def login
    (redirect_to siteadmin_path and return) if logged_in? and current_user.admin?
    if request.post?
      self.current_user = User.authenticate(params[:login], params[:password])
      if admin?
        # @setting.update_attribute('chat_available',true)
        @incomplete_purchases = IncompletePurchase.find(:all)
        unless @incomplete_purchases.nil?
          @incomplete_purchases.each do |purchase|
            Notifier.product_information(purchase,AppConfig.admin_email).deliver
            purchase.destroy
          end
        end
        redirect_back_or_default(:controller => '/admin/base', :action => 'index')
      else
        flash[:notice] = "Invalid login account."
        render :layout => false
      end
    else
      render :layout => false
    end
  end

  def logout
    self.current_user.forget_me if logged_in?
    if admin?
      @setting.update_attribute('chat_available',false)
    end
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logout"
    redirect_back_or_default(:controller => '/admin/base', :action => 'index')
  end

  def enable_disable_chat
    if admin? and @setting.chat_available == false
      @setting.update_attribute('chat_available',true)
    elsif @setting.chat_available == true
      @setting.update_attribute('chat_available',false)
    end
    redirect_to siteadmin_url and return
  end
end

