class Site::AuthenticationsController < ApplicationController
  def index
    @authentications = Authentication.all
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication =
      if omniauth['provider'] == 'twitter'
        Authentication.find_by_provider_and_uid_and_token(omniauth['provider'], omniauth['uid'], omniauth['credentials']['token'])
      elsif omniauth['provider'] == 'facebook'
        Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      end
    user = User.find_by_login(omniauth['info']['nickname'])
    session[:omniauth] = omniauth
    if authentication
      self.current_user = User.find(authentication.user_id)
      current_user.set_last_seen_at
      session[:current_user] = current_user.id
      flash[:notice] = "Signed in successfully."
      redirect_to root_url
    elsif omniauth['provider'].present? and user.present?
      flash[:notice] = "Please login"
      redirect_to "/login?login=#{user.login}&provider=#{omniauth['provider']}&uid=#{omniauth['uid']}&token=#{omniauth['credentials']['token']}"
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        redirect_to signup_url
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to site_authentications_path
  end
end
