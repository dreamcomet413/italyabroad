class Admin::ContactMessagesController < ApplicationController
  before_filter :admin_login_required
  layout "admin"

  def index
    @contact_message = ContactMessage.find(:first)
    if @contact_message.blank?
      redirect_to new_admin_contact_message_path
    else
      redirect_to edit_admin_contact_message_path(:id => @contact_message.id)
    end
  end

  def new
    @contact_message = ContactMessage.new
  end

  def create
    @contact_message = ContactMessage.new(params[:contact_message])
    @contact_message.message.html_safe
    if @contact_message.save
      flash[:message] = "Contact Us Details Successfully submited."
      redirect_to admin_contact_message_path(@contact_message)
    else
      flash[:notice] = @contact_message.show_errors.html_safe
      render action: "new"
    end
  end

  def show
    @contact_message = ContactMessage.find(params[:id])
  end

  def edit
    @contact_message = ContactMessage.find(params[:id])
  end
  
  def update
    @contact_message = ContactMessage.find(params[:id])
    if @contact_message.update_attributes(params[:contact_message])
      flash[:alert] = "Contact Us info is updated successfully"
      redirect_to admin_contact_message_path
    else
      flash[:notice] = @contact_message.show_errors
    end
  end
end

