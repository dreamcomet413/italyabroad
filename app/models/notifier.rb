class Notifier < ActionMailer::Base
  default :from => AppConfig.admin_email
  layout 'mailer'
  def topic_replied_notification(post)
    begin

      setup_email(post.topic.user)
      @subject += "- Someone replied your topic"
      body :topic => post.topic,
       :topic_url => "#{AppConfig.site_url}/topics/post.topic.id",
       :post => post,
       :replied_user => post.user,
       :user => post.topic.user

      rescue => e
        logger.info "################### Unexpected errors when sending email topic replied notification \n #{e.inspect}"
        false
      end

  end

  def news_letter(email, name, news_letter)

    @news_letter = news_letter
    @name = name
    @url =  url_for(:host => AppConfig.site_url, :controller => "site/base", :action => "unsubscribe")
    @news_letter_url = url_for(:host => AppConfig.site_url, :controller => "site/news_letters", :action => "show", :id => news_letter)
    mail(:to => email , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] #{news_letter.name}" , :content_type=> "text/html")
    
  end

  def subscribe(email)
    
    @email = email
    @url =  url_for(:host => AppConfig.site_url, :controller => "site/base", :action => "unsubscribe")
    mail(:to => email , :bcc=> "info@italyabroad.com" , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] Newsletter Subscription Complete!" )
    
  end

  def activation(user)
    @user = user
    @url =   url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "confirmation", :id=>user, :code=>user.activation_code)
    mail(:to => user.email , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] User Activation Code" )
  end

  def change_mail(user)
    @user = user
    @url =   url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "confirmation", :id=>user, :code=>user.activation_code)
    mail(:to => user.email , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] User Account Information Changed" )
  end

  def send_to_friend(email, sender, receiver, message, url)
  
    @email = email
    @sender = sender
    @receiver = receiver
    @message = message
    @url = url
    mail(:to => email , :bcc=> "info@italyabroad.com" , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] Your friend #{sender} has found a product on italyabroad.com that you may like" )
  end

  def account_created(user)
    @user = user
    mail(:to => user.email , :bcc => "info@italyabroad.com", :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] Welcome, Your account has been created")
  end

  def account_data(user)
    @user = user
    mail(:to => user.email , :bcc => "info@italyabroad.com", :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] User Account Information")
  end

  def contact(contact)
    @contact = contact
    mail(:to => "info@italyabroad.com" , :from => contact.email , :subject => "[Italyabroad.com] Contact Request from site")
  end

  def new_review(review)
    @review = review
    @url  = url_for(:host => AppConfig.site_url, :controller => "site/#{review.reviewer_type.pluralize.downcase}", :action => "show", :id=>review.reviewer.id)
    mail(:to => "info@italyabroad.com" , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] New review")
    
  end

  def new_reservation(reservation)
    @reservation = reservation
    mail(:to => reservation.user.email , :bcc=> 'info@italyabroad.com' , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] Reservation Accepted")
  end

  def status_reservation(reservation)
    @reservation = reservation
    mail(:to => reservation.user.email , :bcc=> 'info@italyabroad.com' , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] Reservation Status") 
  end

  def new_order(order)
    @order = order
    @printing_url = ((AppConfig.site_url.to_s[1..3] == "www" ? AppConfig.site_url.to_s : "www." + AppConfig.site_url.to_s) +  "/orders/download_pdf?id=" + order.id.to_s),
    @status_url = ((AppConfig.site_url.to_s[1..3] == "www" ? AppConfig.site_url.to_s : "www." + AppConfig.site_url.to_s) +  "/orders"),
    @tasting_url = ((AppConfig.site_url.to_s[1..3] == "www" ? AppConfig.site_url.to_s : "www." + AppConfig.site_url.to_s) +  "/orders/download_pdf?id=" + order.id.to_s)

    mail(:to => order.user.email , :bcc=> 'info@italyabroad.com' , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] Order Accepted") 
  end

  def status_order(order)
    @order = order
    mail(:to => order.user.email , :bcc=> 'info@italyabroad.com' , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] Order Status") 
  end

  def paid_order(order)
    @order = order
    mail(:to => order.user.email , :bcc=> 'info@italyabroad.com' , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] Order Paid") 
  end

  def comment(comment,user)
    @comment = comment
    @user = user
    mail(:to => user.email , :bcc=> 'info@italyabroad.com' , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] Comment from Site") 

  end
  def reply_comment(comment,user)
    @comment = comment
    @user = user
    mail(:to => user.email , :bcc=> 'info@italyabroad.com' , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] Reply from Admin") 

  end

  def order_details_after_shipping(order)
    
    @order = order
    mail(:to => order.user.email , :bcc=> 'info@italyabroad.com' , :from => "Italyabroad.com <info@italyabroad.com>" , :subject => "[Italyabroad.com] Order Shipped" , :content_type => "text/html")
  end

  def reorder_quantity_notification(product,admin_email)
    @product = product
    mail(:to => admin_email , :from => "info@italyabroad.com" , :subject => "[Itallyabroad.com] Reorder quantity alert: #{product.name}" )
  end

  #send mail to users who do not complete purchase
  def product_information(user,admin_email)
    @user = user
    mail(:to => user.email  , :from => "info@italyabroad.com" , :subject => "[Italyabroad.com] Need some help to sort your wine" , :content_type => "text/html")
  end

  def faq_notification(faq,user)
    @user = user
    @faq = faq
    @url =  url_for(:host => AppConfig.site_url, :controller => "admin/faqs", :action => "edit", :id=>faq.id)
    mail(:to => AppConfig.admin_email  , :from => "info@italyabroad.com" , :subject => "[Italyabroad.com] A Question asked by #{user.name}" , :content_type => "text/html")
  end


  def new_review_added(product,user,admin_email,review)
    
    @product = product
    @review = review
    @user = user

    mail(:to => admin_email  , :from => "info@italyabroad.com" , :subject => "[Italyabroad.com] A review of #{product.name} added" )
      
  end

  def new_order_placed(order,user,admin_email)
    @order = order
    @user = user
    mail(:to => admin_email  , :from => "info@italyabroad.com" , :subject => "[Italyabroad.com] New order from #{user.name}" )
 end

  def new_account_created(user,admin_email)
    @user = user
    @url  = url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "show", :id=>user.id)
    mail(:to => admin_email  , :from => "info@italyabroad.com" , :subject => "[Italyabroad.com] New recipients created by #{user.name}" )
  end

  def invite_a_friend(email,name,friend_name,message)
    @message = message
    @your_name= name 
    @friend_name= friend_name

    mail(:to => email  , :from => "info@italyabroad.com" , :subject => "[Italyabroad.com] An invitation from #{name}" )
  
  end

  def coupon_notification_for_first_review (product,user,coupon_code)
    @product  = product
    @user = user
    @coupon_code = coupon_code
    mail(:to => user.email  , :from => AppConfig.admin_email , :cc=> "info@italyabroad.com" , :subject => "[Italyabroad.com] First review of #{product.name} added" , :content_type=> "text/html" )
  
  end

  def review_invitation(reviews, recipient)
    @products  = reviews.collect{|x| Product.find(x.reviewer_id)},
    @user = recipient
    
    mail(:to => recipient.email  , :from => AppConfig.admin_email , :cc=> "info@italyabroad.com" , :subject => "[Italyabroad.com] Product(s) #{reviews.collect{|x| Product.find(x.reviewer_id).name if x.reviewer_id.present?}.join(",")} - Review Request" , :content_type=> "text/html" )
  
  end

  def new_message_received(message,user,sender)
     
    @message = message
    @user  = user
    @sender = sender
    
    mail(:to => user.email  , :from => "info@italyabroad.com" , :subject => "Message from #{sender.name}"  )
  
  end

  def faq_answered_notification(faq) 
    @faq = faq
    
    mail(:to => faq.user.email  , :from => "info@italyabroad.com" , :subject => "[Italyabroad.com] Your Question is answered by Italyabroad Team"  )
  end


  protected

  def setup_email(user)

    @recipients   = "#{user.email}"
    @subject      = AppConfig.subject
#    @sent_on      = Time.now
    @content_type = "text/html"
  end
end

