class Notifier < ActionMailer::Base
  default :from => AppConfig.admin_email

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
    account    email
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "#{news_letter.name}"
    content_type  "text/html"
    body          :news_letter => news_letter,
                  :name => name,
                  :url   => url_for(:host => AppConfig.site_url, :controller => "site/base", :action => "unsubscribe"),
                  :news_letter_url => url_for(:host => AppConfig.site_url, :controller => "site/news_letters", :action => "show", :id => news_letter)
  end

  def subscribe(email)
    account    email
 #   from          "Italyabroad.com <info@italyabroad.com>"
    bcc           "info@italyabroad.com"
    subject       "[News Letters Italyabroad.com] Subscription Complete!"
    body          :email => email,
                  :url   => url_for(:host => AppConfig.site_url, :controller => "site/base", :action => "unsubscribe")
  end

  def activation(user)
    account    user.email
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Account Italyabroad.com] Activation Code"
    body          :user => user,
                  :url  => url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "confirmation", :id=>user, :code=>user.activation_code)
  end

  def change_mail(user)
    account    user.email
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Account Italyabroad.com] Change Mail"
    body          :user => user,
                  :url  => url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "confirmation", :id=>user, :code=>user.activation_code)
  end

  def send_to_friend(email, sender, receiver, message, url)
    account    email
    bcc           "info@italyabroad.com"
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Italyabroad.com] Your friend #{sender} has found a product on italyabroad.com that you may like"
    body          :url  => url,
                  :sender => sender,
                  :receiver => receiver,
                  :message => message
  end

  def account_created(user)
    account    user.email
    bcc           "info@italyabroad.com"
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Account Italyabroad.com] Account Created"
    body          :user => user
  end

  def account_data(user)
    account    user.email
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Account Italyabroad.com] Account Data"
    body          :user => user
  end

  def contact(contact)
    account    "info@italyabroad.com"
    bcc           "info@italyabroad.com"
#    from          contact.email
    subject       "[Request Italyabroad.com] Request from site"
    body          :contact => contact
  end

  def new_review(review)
    account    "info@italyabroad.com"
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Review Italyabroad.com] New review"
    body          :review => review,
                  :url  => url_for(:host => AppConfig.site_url, :controller => "site/#{review.reviewer_type.pluralize.downcase}", :action => "show", :id=>review.reviewer.id)
  end

  def new_reservation(reservation)
    account    reservation.user.email
    bcc           "info@italyabroad.com"
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Reservation Italyabroad.com] Reservation Accepted"
    body          :reservation => reservation
  end

  def status_reservation(reservation)
    account    reservation.user.email
    bcc           "info@italyabroad.com"
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Reservation Italyabroad.com] Reservation Status"
    body          :reservation => reservation
  end

  def new_order(order)
    account    order.user.email
    bcc           "info@italyabroad.com"
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Order Italyabroad.com] Order Accepted"
    #body          :order => order,
    #              :tasting_url => url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "print_tasting", :id=>order.id),
    #              :invoice_url => url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "print_invoice", :id=>order.id),
    #              :customer_url => url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "orders")

    body          :order => order,
                  :printing_url => ((AppConfig.site_url.to_s[1..3] == "www" ? AppConfig.site_url.to_s : "www." + AppConfig.site_url.to_s) +  "/orders/download_pdf?id=" + order.id.to_s),
                  :status_url => ((AppConfig.site_url.to_s[1..3] == "www" ? AppConfig.site_url.to_s : "www." + AppConfig.site_url.to_s) +  "/orders"),
                  :tasting_url => ((AppConfig.site_url.to_s[1..3] == "www" ? AppConfig.site_url.to_s : "www." + AppConfig.site_url.to_s) +  "/orders/download_pdf?id=" + order.id.to_s)



  end

  def status_order(order)
    account    order.user.email
    bcc           "info@italyabroad.com"
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Order Italyabroad.com] Order Status"
    body          :order => order
  end

  def paid_order(order)
    account    order.user.email
    bcc           "info@italyabroad.com"
#    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Order Italyabroad.com] Order Paid"
    body          :order => order
  end

  def comment(comment,user)
    account    comment.email
    bcc           "info@italyabroad.com"
#    from          "info@italyabroad.com"
    subject       "[Request Italyabroad.com] Request from site"
    body           :comment => comment,
                   :user => user
  end

  def order_details_after_shipping(order)
    account    order.user.email
    bcc           "info@italyabroad.com"
#    from          "Italyabroad.com <info@italyabroad.com>"
    #subject       "[Order Italyabroad.com] Order Paid"
    subject       "Italyabroad.com Order shipped"
    body          :order=>order
    content_type "text/html"
  end

  def reorder_quantity_notification(product,admin_email)
    account "#{admin_email}"
#    from "info@italyabroad.com"
    subject  "Reorder quantity alert :" + product.name
    body    :product=>product
  end

  #send mail to users who do not complete purchase
  def product_information(user,admin_email)
    account "#{user.email}"
#    from "info@italyabroad.com"
    subject  "Need some help to sort your wine"
    body    :user=>user
    content_type "text/html"
  end

  def faq_notification(faq,user)
    account  AppConfig.admin_email
#    from        "info@italyabroad.com"
    subject     "A Question asked by #{user.name}"
    body        :faq=>faq,
                :url  => url_for(:host => AppConfig.site_url, :controller => "admin/faqs", :action => "edit", :id=>faq.id),
                :user=>user
  end


  def new_review_added(product,user,admin_email,review)
    account "#{admin_email}"
#    from "info@italyabroad.com"
    subject  "A review of " + product.name + "added"
    body      :product  => product,
              :review=>review,
                :user=>user
  end

  def new_order_placed(order,user,admin_email)
    account "#{admin_email}"
#    from "info@italyabroad.com"
    subject  "New order from  " + user.name
    body      :order  => order,
             :user=>user
  end

  def new_account_created(user,admin_email)
    account "#{admin_email}"
#    from "info@italyabroad.com"
    subject  "New Account created by  " + user.name
    body     :user=>user,
            :url  => url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "show", :id=>user.id)
  end

  def invite_a_friend(email,name,friend_name,message)
    account "#{email}"
 #   from "info@italyabroad.com"
    subject  "An invitation from  " + "#{name}"
    body  :message =>message,:your_name=>name,:friend_name=>friend_name

  end
  def coupon_notification_for_first_review (product,user,coupon_code)

    account "#{user.email}"
#    from AppConfig.admin_email
    cc       ["info@italyabroad.com"]
    subject  "First review of " + product.name + " added"
    body      :product  => product,
              :user=>user,
              :coupon_code=>coupon_code
    content_type "text/html"
  end

  def new_message_received(message,user,sender)
    account "#{user.email}"
#    from "info@italyabroad.com"
    subject  "Message from  " + "#{sender.name}"
    body  :message =>message,:user=>user,:sender=>sender
  end

  def faq_answered_notification(faq)
    account "#{faq.user.email}"
#    from "info@italyabroad.com"
    subject  "Your Question is answered by Italyabroad Team"
    body  :faq =>faq
  end


  protected

  def setup_email(user)
    @account   = "#{user.email}"
    @subject      = AppConfig.subject
#    @sent_on      = Time.now
    @content_type = "text/html"
  end
end

