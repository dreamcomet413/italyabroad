ActionController::Routing::Routes.draw do |map|


  map.resources :chat, :controller => 'site/chat',:collection =>{:create_chat_user=> :any,:send_data => :any}
  map.meet_us 'supplier', :controller => 'site/base', :action => 'supplier'
#  map.meet_us 'wine-club', :controller => 'site/base', :action => 'wine_club'
  # about us
  map.contact_us 'about-us/contact-us', :controller => 'site/base', :action => 'contact'
  map.corporate 'about-us/corporate-services', :controller => 'site/base', :action => 'corporate'
  map.wholesale_enquiry 'about-us/wholesale-enquiry', :controller => 'site/base', :action => 'enquiries'
  map.about_us 'about-us', :controller => 'site/base', :action => 'about_us'
  map.our_principles 'about-us/our-principles', :controller => 'site/base', :action => 'our_principles'
  map.meet_us 'about-us/meet-us', :controller => 'site/base', :action => 'meet_us'

  # help
  map.terms_and_conditions 'help/terms-and-conditions', :controller => 'site/base', :action => 'conditions'
  map.privacy_policy 'help/privacy-policy', :controller => 'site/base', :action => 'privacy'
  map.delivery_services 'help/delivery-services', :controller => 'site/base', :action => 'delivery_services'
  map.managing_account 'help/managing-account', :controller => 'site/base', :action => 'managing_account'
  map.contact_details 'help/contact-details', :controller => 'site/base', :action => 'contact_details'
  map.sitemap 'sitemap', :controller => 'site/base', :action => 'sitemap'
  map.connect "sitemap.xml", :controller => "site/base", :action => "google_sitemap"
  map.franchise "wine-franchising",:controller => 'site/base', :action => 'franchise'
#  map.connect "products.xml",:controller=>'site/products',:action=>'index'

 # map.testimonial 'testimonial', :controller => 'site/base', :action => 'testimonial'
  map.testimonial 'testimonial', :controller => 'site/testimonials', :action => 'index'
  map.popular 'popular', :controller => 'site/base', :action => 'popular'
  map.signup 'signup', :controller => 'site/customers', :action => "new"
  map.login   'login', :controller => 'site/base', :action => 'login'
  map.guest_login   'guest_login', :controller => 'site/base', :action => 'guest_login'
  map.logout  'logout', :controller => 'site/base', :action => 'logout'
  map.subscribe_dali_news 'subscribe-dali-news', :controller => 'site/base', :action => 'subscribe'
  map.create_subscription 'subscriptions', :controller => 'site/base', :action => 'create_subscription', :method => :post
  map.subscription_complete 'thank-you', :controller => 'site/base', :action => 'subscription_complete'
  map.unsubscribe_dali_news 'unsubscribe-dali-news', :controller => 'site/base', :action => 'unsubscribe'
  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  map.siteadmin 'siteadmin', :controller => 'admin/base', :action => 'index'
  map.admin_login 'admin/login', :controller => 'admin/base', :action => 'login'
  map.blog_by_month_page 'blog/:year/:month', :controller => 'site/blog', :action => 'index', :year => /\d{4}/, :month => /\d{1,2}/
  map.print_invoice 'orders/:id/invoice', :controller => 'site/orders', :action => 'invoice'
  map.account 'my-account', :controller => 'site/customers', :action => 'account'
  map.follow 'follow/:user_id', :controller => 'site/customers', :action => 'follow'
  map.unfollow 'unfollow/:user_id', :controller => 'site/customers', :action => 'unfollow'

  map.grape_guide 'grape-guide', :controller => 'site/grapes', :action => 'index'
  map.request_new_password 'request-new-password', :controller => 'site/customers', :action => :request_new_password
  map.wine_events 'wine-events', :controller => 'site/categories', :action => 'show', :category => "events"
  map.wine_community 'wine-community', :controller => 'site/forums', :action => 'index'

  map.connect "grapes/search_results", :controller => 'site/grapes', :action => 'search_results'

  map.resources :products, :controller => 'site/products', :only => [:index, :show,:wine_of_the_week,:food_of_the_week] do |products|
    products.resources :reviews, :controller => 'site/reviews', :only => [:new, :create]
    products.resources :cart, :controller => 'site/cart', :only => [:create, :update, :destroy], :collection => {:empty => :get}
    products.resources :wish_list, :controller => 'site/wish_list', :only => [:index, :create, :destroy]
  products.resources :wine_list, :controller => 'site/wine_lists', :only => [:index, :create, :destroy]
  end
   map.resources :recipes, :controller => 'site/recipes',:collection=>{:recipes_list=>:get}
  map.resources :recipes, :controller => 'site/recipes'  do |recipes|
    recipes.resources :reviews, :controller => 'site/reviews', :only => [:new, :create]
  end


  map.resources :forums, :controller => "site/forums" do |forum|
    forum.resources :topics, :controller => "site/topics"  do |topic|
      topic.resources :posts, :controller => "site/posts"
      topic.resource :monitorship, :controller => "site/monitorships"
    end
  end
  map.resources :faqs,:controller => 'site/faqs'
  map.resources :news_letters, :controller => 'site/news_letters', :only => [:show]
  map.resources :producers, :controller => 'site/producers', :only => [:show,:index]
  map.resources :regions, :controller => 'site/regions', :only => [:show,:index]
  map.resources :grapes, :controller => 'site/grapes', :only => [:index, :show]

  map.resources :wine_lists, :controller => 'site/wine_lists'
  map.resources :reviews, :controller => 'site/reviews'
  map.resources :messages, :controller => 'site/messages',:collection=>[:send_reply,:send_message]
   map.resources :comments, :controller => 'site/comments'
  map.resources :search, :controller => 'site/search', :only => [:index],:collection=>[:find_users,:find_wines,:find_foods,:find_recipes,:find_producers,:find_wine_events, :find_grapes]
  map.resources :cart, :controller => 'site/cart', :only => [:index, :update], :collection => {:empty => :get, :continue_shopping => :get}
  map.connect 'site/cart/gift_options',:controller=>'site/cart',:action=>'gift_options'
  map.connect 'site/checkouts/order_confirmation',:controller=>'site/checkouts',:action=>'order_confirmation'
  map.connect 'site/cart/update_gift',:controller=>'site/cart',:action=>'update_gift'
  map.resources :ship_addresses, :controller => 'site/ship_addresses'
  map.resources :checkouts, :controller => 'site/checkouts', :only => [:index], :collection => {:confirm_address => :post, :payment => :get, :paypal => :get, :confirmed => :get}
  map.resources :orders, :controller => 'site/orders', :only => [:index, :new, :create, :show],:collection => {:download_pdf => :any}
  map.resources :customers, :controller => 'site/customers', :collection => {:account => :get, :update_default_pic => :get, :request_new_password => :get, :find => :post,:send_message=>:post}
  map.resources :image, :controller => 'site/images', :only => [:show], :path_prefix => ':image_type'
  map.resources :blog, :controller => 'site/blog', :only => [:index, :show], :member => {:comment => :any}
  map.resources :posts, :controller => 'site/posts', :collection => { :search => :post }
  map.resources :wish_list, :controller => 'site/wish_list', :only => [:index, :create, :destroy]
   map.resources :wine_lists, :controller => 'site/wine_lists', :only => [:index, :create, :destroy]

  %w(forum).each do |attr|
    map.resources :posts, :controller => "site/posts", :name_prefix => "#{attr}_", :path_prefix => "/#{attr.pluralize}/:#{attr}_id"
  end
  map.connect 'admin/products/delete_products_of_the_week', :controller => '/admin/products', :action => 'delete_products_of_the_week'

  map.connect 'admin/products/products_of_the_week', :controller => '/admin/products', :action => 'products_of_the_week'
  map.connect "admin/products/xml", :controller => '/admin/products', :action => 'xml'
  map.connect "site/orders/show_order_details",:controller => '/site/orders', :action => 'show_order_details'
 map.connect "admin/products/products_sortby_quantity",:controller => '/admin/products',:action =>'products_sortby_quantity'
  map.connect "site/orders/review",:controller => '/site/orders', :action => 'review'

  map.connect "admin/recipes/xml", :controller => '/admin/recipes', :action => 'xml'
  map.xml 'admin/xml', :controller => 'admin/xml', :action => 'index'
  map.xml_options 'admin/xml/xml_options', :controller => 'admin/xml', :action => 'xml_options'
  map.eval_xml 'admin/xml/eval_xml', :controller => 'admin/xml', :action => 'eval_xml'

map.eval_xml_g_comptible 'admin/xml/eval_xml_g_comptible', :controller => 'admin/xml', :action => 'eval_xml_g_comptible'

  map.namespace :admin do |admin|
    admin.resources :testimonials
    admin.resources :faqs
    admin.resources :shipping_agencies
    admin.resources :occasions
    admin.resources :about_us
    admin.resources :regions do |region|
      region.resources :images, :only => [:destroy]
    end
    admin.resources :producers do |producer|
      producer.resources :images, :only => [:destroy]
    end
    admin.resources :grapes do |grape|
      grape.resources :images, :only => [:destroy]
    end
    admin.resources :forums
    admin.resources :categories
    admin.resources :deliveries
    admin.resources :cupons , :collection => {:product_list => :any}
    admin.resources :forums
    admin.resources :posts
    admin.resources :comments
    map.connect 'admin/comments/approve_comment', :controller => '/admin/comments', :action => 'approve_comment'
    admin.resources :reviews
    admin.resources :orders, :only => [:index, :show, :destroy], :member => {:print_tasting => :get, :print_invoice => :get, :print_picking_list => :get,:delivery_details=>:get}
    admin.resources :users
    admin.resources :customers,:collection=>{:print_user_details=>:get}
    admin.resources :gift_options
    admin.resources :subscriptions
    admin.resources :news_letters do |news_letters|
      news_letters.resources :images, :only => [:destroy]
    end
    admin.resources :recipes do |recipes|
      recipes.resources :images, :only => [:destroy]
      recipes.resources :resources, :only => [:destroy]
    end
    admin.resources :resources, :only => [:destroy]
    admin.resources :images, :only => [:destroy]
    admin.resources :products do |product|
      product.resources :images, :only => [:destroy]
      product.resources :resources, :only => [:destroy]
    end
    admin.resources :settings, :only => [:index, :update] do |setting|
      setting.resources :images, :only => [:destroy]
      setting.resources :resources, :only => [:destroy]
    end
  end
map.update_franchise_details 'admin/settings/update_franchise_details', :controller => 'admin/settings', :action => 'update_franchise_details'
  map.product_meta 'admin/products/:id/meta', :controller => 'admin/products', :action => 'meta'
  map.product_categories 'admin/products/:id/categories', :controller => 'admin/products', :action => 'categories'
  map.product_extra 'admin/products/:id/extra', :controller => 'admin/products', :action => 'extra'
  map.product_ideal_with 'admin/products/:id/ideal_with', :controller => 'admin/products', :action => 'ideal_with'
  map.product_how_to_cook 'admin/products/:id/how_to_cook', :controller => 'admin/products', :action => 'how_to_cook'
  map.product_correlation 'admin/products/:id/correlation', :controller => 'admin/products', :action => 'correlation'
  map.product_images 'admin/products/:id/images', :controller => 'admin/products', :action => 'images'
  map.product_files 'admin/products/:id/files', :controller => 'admin/products', :action => 'files'
  map.included_products 'admin/products/:id/included_products', :controller => 'admin/products', :action => 'included_products'


  map.recipe_meta 'admin/recipes/:id/meta', :controller => 'admin/recipes', :action => 'meta'
  map.recipe_extra 'admin/recipes/:id/extra', :controller => 'admin/recipes', :action => 'extra'
  map.recipe_wine 'admin/recipes/:id/wine', :controller => 'admin/recipes', :action => 'wine'
  map.recipe_correlation 'admin/recipes/:id/correlation', :controller => 'admin/recipes', :action => 'correlation'
  map.recipe_images 'admin/recipes/:id/images', :controller => 'admin/recipes', :action => 'images'
  map.recipe_files 'admin/recipes/:id/files', :controller => 'admin/recipes', :action => 'files'

  map.news_letter_correlation 'admin/news_letters/:id/correlation', :controller => 'admin/news_letters', :action => 'correlation'
  map.news_letter_images 'admin/news_letters/:id/images', :controller => 'admin/news_letters', :action => 'images'

  %w(wine food hampers).each do |category|
    map.connect "#{category}", :controller => 'site/categories', :action => 'show', :category => category
    map.connect "#{category}/:category/", :controller => 'site/categories', :action => 'show_sub', :parent => category
    map.connect "#{category}/all_mixedcase_image/:parent", :controller => 'site/categories', :action => 'all_mixedcase_image'
    map.connect "#{category}/special_offer/:parent", :controller => 'site/categories', :action => 'special_offer', :parent => category
  end
  #special case
  map.connect "/wine-tours", :controller => 'site/categories', :action => 'show', :category => 'wine-tours'

  #the following route map.connect "/wine-tours/invite_a_friend" must come before map.connect "/wine-tours/:id" route definition
  map.connect "/wine-tours/invite_a_friend", :controller => 'site/products', :action => 'invite_a_friend', :category => 'wine-tours'

  map.connect "/wine-tours/:id", :controller => 'site/products', :action => 'show', :category => 'wine-tours'
  map.connect "/wine-events", :controller => 'site/categories', :action => 'show', :category => "events"
  map.connect "/wine-events/:id", :controller => 'site/products', :action => 'show', :category => "events"
  map.connect "/events", :controller => 'site/categories', :action => 'show', :category => "events"
  map.connect "/events/:id", :controller => 'site/products', :action => 'show', :category => "events"
  map.connect "/wine-club/", :controller => 'site/categories', :action => 'show', :category => "wine-club"
  #the following route map.connect "/wine-club/invite_a_friend" must come before map.connect "/wine-club/:id" route definition
   map.connect "/wine-club/invite_a_friend", :controller => 'site/products', :action => 'invite_a_friend', :category => 'wine-club'
  map.connect "/wine-club/:id", :controller => 'site/products', :action => 'show', :category => "wine-club"


  #end
  map.nested_products '/:root_category/:category/:id', :controller => 'site/products', :action => 'show'
  map.nested_product '/:category/:id', :controller => 'site/products', :action => 'show'
  map.nested_categories '/:parent_category/:sub_category/', :controller => 'site/products', :action => 'index'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  map.connect '*path', :controller => 'site/base', :action => 'index'
  map.root :controller => 'site/base', :action => 'index'
end

