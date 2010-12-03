class Site::ChatController < ApplicationController
  protect_from_forgery :only => [:index]
  layout  false
  
  def index
    session[:juggernaut_channels] = ["chat_channel"]
  end

  def send_data
#    i+=1
    time = "<span style='font:normal 13px arial;'>[#{(Time.now).strftime '%d%b-%T'}]</span>"
    if current_user != :false      
      user = current_user.name
    else
      user = session[:chat_user_name]
     # i+=1
    end
    #    	input_data = CGI.escapeHTML(params[:chat_input])
    #	    data = "new Insertion.Top('chat_data', '<li>#{input_data}</li>');"
    #	    render :text => data, :juggernaut => session[:juggernaut_channels] || true
    render :juggernaut  do |page|
      p request.remote_ip
      if @old_user != user
      page.insert_html :bottom, 'chat_data', "<li>#{time}<span style='font:bold 14px Arial;color:blue'>#{user}:</span> #{h params[:chat_input]}</li>"      
      else
      page.insert_html :bottom, 'chat_data', "<li> #{h params[:chat_input]}</li>"
      end
      @old_user = user
    end
    render :nothing => true
  end

  def create_chat_user
    p params[:chat_user]
   session[:chat_user_name] = params[:chat_user]
   redirect_to chat_index_path
  end

end
