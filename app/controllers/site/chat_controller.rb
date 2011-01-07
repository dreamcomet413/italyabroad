class Site::ChatController < ApplicationController
  protect_from_forgery :only => [:index]
  layout  false

  def index
    session[:juggernaut_channels] = ["chat_channel"]
    if current_user != :false
       session[:chat_user_name] = current_user.login
     end

  end

  def send_data
#    i+=1
    time = "<span class='time'>[#{(Time.now).strftime '%d%b-%T'}]</span>"


    if session[:chat_user_name] == "admin"

    if !params[:reply_to].blank?
      render :juggernaut  => {:type => :send_to_clients_on_channel, :channel => session[:juggernaut_channels], :client_ids => [params[:reply_to], session[:chat_user_name]] }  do |page|
        p request.remote_ip
        page.insert_html :bottom, 'chat_data', "<li>#{time}<span class='support_name'>#{session[:chat_user_name]}:</span> <span class='support_chat_data'>#{h params[:chat_input]}</span></li>"
      end
    else

      render :juggernaut  => {:type => :send_to_client_on_channel, :channel => session[:juggernaut_channels], :client_id => "admin" }  do |page|
        p request.remote_ip
        page.insert_html :bottom, 'chat_data', "<li>#{time}<span class='support_name'>#{session[:chat_user_name]}:</span> <span class='support_chat_error'>No Chat User Selected !</span></li>"
      end
    end




    else


      render :juggernaut  => {:type => :send_to_client_on_channel, :channel => session[:juggernaut_channels], :client_id => "admin" }  do |page|
        reply_link = "<a class=\"reply_link\" href=\"#\" onclick=\"$('reply_to').value='#{session[:chat_user_name]}'; $('label_reply').innerHTML='Reply to :: #{session[:chat_user_name]}'; $(this).remove(); return false;\">Reply</a>"
        p request.remote_ip
        page.insert_html :bottom, 'chat_data', "<li>#{time}<span class='chat_user_name'>#{session[:chat_user_name]}:</span> <span class='chat_user_data'>#{h params[:chat_input]}</span> #{reply_link}</li>"
      end

      render :juggernaut  => {:type => :send_to_client_on_channel, :channel => session[:juggernaut_channels], :client_id => session[:chat_user_name] }  do |page|
        reply_link = "<a href=\"#\" onclick=\"$('reply_to').value='#{session[:chat_user_name]}';return false;\">Reply</a>"
        page.insert_html :bottom, 'chat_data', "<li>#{time}<span class='chat_user_name'>#{session[:chat_user_name]}:</span> <span class='chat_user_data'>#{h params[:chat_input]}</span> </li>"
      end
    end

    render :nothing => true
  end

  def create_chat_user
    p params[:chat_user]
   if params[:chat_user].to_s.downcase == "admin"
     flash[:notice] = "Chat username \"admin\" not allowed "
   else
    session[:chat_user_name] = params[:chat_user]
   end

   redirect_to chat_index_path
  end


end

