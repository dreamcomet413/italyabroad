class Import
  def self.start
    for old_user in OldUser.find(:all)
      User.create(:login                  => Import.make_login(old_user),                          
                  :name                   => old_user.first_name,                                  
                  :surname                => old_user.last_name,                                   
                  :address                => old_user.address_1,                                   
                  :address_2              => old_user.address_2,                                   
                  :country                => old_user.country,                                     
                  :city                   => old_user.town,                                        
                  :cap                    => old_user.post_code,                                   
                  :telephone              => old_user.telephone,                                   
                  :email                  => old_user.email,                                       
                  :password               => old_user.password,                                    
                  :password_confirmation  => old_user.password,
                  :title                  => old_user.title,
                  :know_through           => old_user.know_us,
                  :type_id                => 2,
                  :ship_address           => old_user.b2b_delivery_address)
    end
  end
  
  def self.make_login(old_user)
    login  = ""
    login += old_user.first_name.slice(0,1).downcase
    login += "x" if login.blank?
    login += "."
    login += old_user.last_name.downcase.gsub(/[^a-z0-9]+/, "").gsub(/-+$/, "").gsub(/^-+$/, "")
    return login 
  end
end