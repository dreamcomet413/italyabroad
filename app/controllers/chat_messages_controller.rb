class ChatMessagesController < ApplicationController
  layout "chat"

  def index
    redirect_to :take_username_chat_messages and return if ((current_user == :false) && !params[:with].present?)
    if !(current_user == :false)
      if current_user.admin?
        @chat_messages = ChatMessage.order("created_at DESC").limit(5).reverse
      else
        @chat_messages = ChatMessage.where("message_to = ? OR message_from = ?", current_user.name.parameterize, current_user.name.parameterize).order("created_at ASC").limit(100)
      end
    else
      @chat_messages = ChatMessage.where("message_to = ? OR message_from = ?", params[:with].parameterize, params[:with].parameterize).order("created_at ASC").limit(100)
    end
  end


  def take_username

  end

  def create
    @chat_message = ChatMessage.create!(params[:chat_message])
    @message_to = nil
    if (@chat_message.message_to == "admin")
      publish_to = "/chat_messages/new/#{@chat_message.message_from}"
    else
      publish_to = "/chat_messages/new/#{@chat_message.message_to}"
    end

    PrivatePub.publish_to(publish_to, chat_message: @chat_message)
  end


end
