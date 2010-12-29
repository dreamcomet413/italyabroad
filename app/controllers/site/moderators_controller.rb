class Site::ModeratorsController < ApplicationController

	before_filter :site_login_required
	#before_filter :admin_login_required
  layout "site"

  def destroy
    Moderatorship.delete_all ['id = ?', params[:id]]
    redirect_to user_path(params[:user_id])
  end

  alias authorized? admin?
end

