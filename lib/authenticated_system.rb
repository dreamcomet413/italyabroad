module AuthenticatedSystem
  protected
    def current_user
      @current_user ||= (session[:user] && User.find_by_id(session[:user])) || :false
    end

    def current_user=(new_user)
      session[:user] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
      @current_user = new_user
    end

    def admin?
      current_user != :false && current_user.type.name.upcase == "ADMIN" && active?
    end

    def active?
      current_user != :false && current_user.active
    end

    def logged_in?
      current_user != :false
    end

    def admin_login_required
      username, passwd = get_auth_data
      self.current_user ||= User.authenticate(username, passwd) if username && passwd
      (logged_in? && admin?) || (User.count == 0) ? true : access_denied('admin')
    end

    def site_login_required
      username, passwd = get_auth_data
      self.current_user ||= User.authenticate(username, passwd) if username && passwd
      logged_in? ? true : access_denied('site')
    end

    def chef_login_required
       username, passwd = get_auth_data
      self.current_user ||= User.authenticate(username, passwd) if username && passwd
    (logged_in? && chef?) || (User.count == 0) ? true : access_denied('site')
    flash[:notice] = 'You have to login as a chef to add new recipes'
    end

      def chef?
      current_user != :false && current_user.type.name.upcase == "CHEF" && active?
    end

    def access_denied(part)
      store_location
      redirect_to(admin_login_url) and return if part == "admin"
      redirect_to(login_url) and return if part == "site"
      return false
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(default)
      session[:return_to] = nil
    end

    def self.included(base)
      base.send :helper_method, :current_user, :logged_in?, :admin?, :active?
    end
  private
    @@http_auth_headers = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization)
    # gets BASIC auth info
    def get_auth_data
      auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
      auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
      return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil]
    end
end

