require "juggernaut"

class Site::ChatController < ApplicationController
  protect_from_forgery :only => [:index]
  layout  false

  def index
    session[:juggernaut_channels] = ["chat_channel"]
    @support_user = Setting.find(:first).support

    #@support_status = Juggernaut.show_client(@support_user) ? true : false
    @support_status = true

    if current_user != :false
      session[:chat_user_name] = current_user.login
    end
  end

  def send_message
    @messg = params[:msg_body]
    @sender = params[:sender]
    @time = "<span class='time'>[#{(Time.now).strftime '%d%b-%T'}]</span>".html_safe()
    Juggernaut.publish(select_channel("/channel1_channel2"), parse_chat_message(params[:msg_body], params[:sender]))
    respond_to do |format|
      format.js
    end
  end

  def send_data
#    i+=1
    @support_user = Setting.find(:first).support

    time = "<span class='time'>[#{(Time.now).strftime '%d%b-%T'}]</span>"

    respond_to do |format|
      format.js do
        if session[:chat_user_name] == @support_user

          if !params[:reply_to].blank?
            render :juggernaut  => {:type => :send_to_clients_on_channel, :channel => session[:juggernaut_channels], :client_ids => [params[:reply_to], @support_user] }  do |page|
              p request.remote_ip
              page.insert_html :bottom, 'chat_data', "<li>#{time}<span class='support_name'>#{session[:chat_user_name]}:</span> <span class='support_chat_data'>#{h params[:chat_input]}</span></li>"
              page.call 'scrollup',"chat_data"
              page.call 'window_to_front'
            end
          else

            render :juggernaut  => {:type => :send_to_client_on_channel, :channel => session[:juggernaut_channels], :client_id => @support_user}  do |page|
              p request.remote_ip
              page.insert_html :bottom, 'chat_data', "<li>#{time}<span class='support_name'>#{session[:chat_user_name]}:</span> <span class='support_chat_error'>No Chat User Selected !</span></li>"
              page.call 'scrollup',"chat_data"

            end
          end




        else


          render :juggernaut  => {:type => :send_to_client_on_channel, :channel => session[:juggernaut_channels], :client_id => @support_user }  do |page|
            reply_link = "<a class=\"reply_link\" href=\"#\" onclick=\"$('reply_to').value='#{session[:chat_user_name]}'; $('label_reply').innerHTML='Reply to :: #{session[:chat_user_name]}'; $(this).remove(); return false;\">Reply</a>"
            p request.remote_ip
            page.insert_html :bottom, 'chat_data', "<li>#{time}<span class='chat_user_name'>#{session[:chat_user_name]}:</span> <span class='chat_user_data'>#{h params[:chat_input]}</span> #{reply_link}</li>"
            page.call 'scrollup',"chat_data"
            page.call 'window_to_front'

          end

          render :juggernaut  => {:type => :send_to_client_on_channel, :channel => session[:juggernaut_channels], :client_id => session[:chat_user_name] }  do |page|
            page.insert_html :bottom, 'chat_data', "<li>#{time}<span class='chat_user_name'>#{session[:chat_user_name]}:</span> <span class='chat_user_data'>#{h params[:chat_input]}</span> </li>"
            page.call 'scrollup',"chat_data"
            page.call 'window_to_front'

          end
        end
      end
    end
    render :nothing => true
  end

  def create_chat_user
    p params[:chat_user]
    if params[:chat_user].to_s.downcase == @support_user.to_s.downcase
      flash[:notice] = "Chat username #{@support_user} not allowed "
    else
      session[:chat_user_name] = params[:chat_user]
    end

    redirect_to site_chat_index_path
  end

  private

  def parse_chat_message(msg, user)
    return "#{user}: #{msg}"
  end

  def select_channel(receiver)
    puts "#{receiver}"
    return "/site/chat#{receiver}"
  end



end

