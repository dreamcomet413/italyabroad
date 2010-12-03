class Notifier < ActionMailer::Base
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
    recipients    email
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "#{news_letter.name}"
    content_type  "text/html"
    body          :news_letter => news_letter,
                  :name => name,
                  :url   => url_for(:host => AppConfig.site_url, :controller => "site/base", :action => "unsubscribe"),
                  :news_letter_url => url_for(:host => AppConfig.site_url, :controller => "site/news_letters", :action => "show", :id => news_letter)
  end
  
  def subscribe(email)
    recipients    email
    from          "Italyabroad.com <info@italyabroad.com>"
    bcc           "info@italyabroad.com"
    subject       "[News Letters Italyabroad.com] Subscription Complete!"
    body          :email => email,
                  :url   => url_for(:host => AppConfig.site_url, :controller => "site/base", :action => "unsubscribe")
  end
  
  def activation(user)
    recipients    user.email
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Account Italyabroad.com] Activation Code"
    body          :user => user,
                  :url  => url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "confirmation", :id=>user, :code=>user.activation_code)
  end
  
  def change_mail(user)
    recipients    user.email
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Account Italyabroad.com] Change Mail"
    body          :user => user,
                  :url  => url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "confirmation", :id=>user, :code=>user.activation_code)
  end
  
  def send_to_friend(email, sender, receiver, message, url)
    recipients    email
    bcc           "info@italyabroad.com"
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Italyabroad.com] Your friend #{sender} has found a product on italyabroad.com that you may like"
    body          :url  => url,
                  :sender => sender,
                  :receiver => receiver,
                  :message => message
  end
  
  def account_created(user)
    recipients    user.email
    bcc           "info@italyabroad.com"
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Account Italyabroad.com] Account Created"
    body          :user => user
  end
  
  def account_data(user)
    recipients    user.email
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Account Italyabroad.com] Account Data"
    body          :user => user
  end
  
  def contact(contact)
    recipients    "info@italyabroad.com"
    bcc           "info@italyabroad.com"
    from          contact.email
    subject       "[Request Italyabroad.com] Request from site"
    body          :contact => contact
  end
  
  def new_review(review)
    recipients    "info@italyabroad.com"
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Review Italyabroad.com] New review"
    body          :review => review,
                  :url  => url_for(:host => AppConfig.site_url, :controller => "site/#{review.reviewer_type.pluralize.downcase}", :action => "show", :id=>review.reviewer.id)
  end
  
  def new_reservation(reservation)
    recipients    reservation.user.email
    bcc           "info@italyabroad.com"
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Reservation Italyabroad.com] Reservation Accepted"
    body          :reservation => reservation
  end
  
  def status_reservation(reservation)
    recipients    reservation.user.email
    bcc           "info@italyabroad.com"
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Reservation Italyabroad.com] Reservation Status"
    body          :reservation => reservation
  end
  
  def new_order(order)
    recipients    order.user.email
    bcc           "info@italyabroad.com"
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Order Italyabroad.com] Order Accepted"
    body          :order => order,
                  :tasting_url => url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "print_tasting", :id=>order.id),
                  :invoice_url => url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "print_invoice", :id=>order.id),
                  :customer_url => url_for(:host => AppConfig.site_url, :controller => "site/customers", :action => "orders")
  end
  
  def status_order(order)
    recipients    order.user.email
    bcc           "info@italyabroad.com"
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Order Italyabroad.com] Order Status"
    body          :order => order
  end
  
  def paid_order(order)
    recipients    order.user.email
    bcc           "info@italyabroad.com"
    from          "Italyabroad.com <info@italyabroad.com>"
    subject       "[Order Italyabroad.com] Order Paid"
    body          :order => order
  end

  def comment(comment,user)
    recipients    comment.email
    bcc           "info@italyabroad.com"
    from          "info@italyabroad.com"
    subject       "[Request Italyabroad.com] Request from site"
    body           :comment => comment,
                   :user => user
  end

  protected
  
  def setup_email(user)
    @recipients   = "#{user.email}"
    @from         = AppConfig.email_from_name
    @subject      = AppConfig.subject
    @sent_on      = Time.now
    @content_type = "text/html"
  end
end