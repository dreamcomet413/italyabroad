class Site::MessagesController < ApplicationController
  before_filter :site_login_required
  def index
    @messages = Message.where(['user_id =?',params[:id]]).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    for msg in @messages
      msg.update_attribute('read_or_not',true)
    end
    respond_to do |format|
      format.html { render :layout => 'site' }
    end
  end

  def create
    @message = Message.new(params[:message])
    if @message.save
      redirect_to customer_path(@message.user_id)
    end
  end

  def send_reply
    respond_to do |format|
      format.html{ render :update do |page|
        @message = Message.find(params[:msg_id])
        page.replace_html 'reply' + params[:msg_id],:partial=>'new_message',:object=>@message
      end
      }
    end
  end

  def send_message
    @message = Message.new(:name=>params[:name],:user_id=>params[:user_id],:send_by_id=>params[:send_by_id])
    if @message.save
      Notifier.new_message_received(params[:name],User.find(params[:user_id]),User.find(params[:send_by_id])).deliver
      redirect_to  account_path
    else
      flash[:notice] = @message.show_errors
      redirect_to customer_path(params[:user_id])
    end
  end

end

