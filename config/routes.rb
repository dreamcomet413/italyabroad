ItalyabroadNew::Application.routes.draw do

  resources :chat do
    match :create_chat_user, :on => :collection
    match :send_data, :on => :collection
  end

  match 'supplier' => 'site/base#supplier', :as => :meet_us
  match 'about-us/contact-us' => 'site/base#contact', :as => :contact_us
  match 'about-us/corporate-services' => 'site/base#corporate', :as => :corporate
  match 'about-us/wholesale-enquiry' => 'site/base#enquiries', :as => :wholesale_enquiry
  match 'about-us' => 'site/base#about_us', :as => :about_us
  match 'about-us/our-principles' => 'site/base#our_principles', :as => :our_principles
  match 'about-us/meet-us' => 'site/base#meet_us', :as => :meet_us
  match 'help/terms-and-conditions' => 'site/base#conditions', :as => :terms_and_conditions
  match 'help/privacy-policy' => 'site/base#privacy', :as => :privacy_policy
  match 'help/delivery-services' => 'site/base#delivery_services', :as => :delivery_services
  match 'help/managing-account' => 'site/base#managing_account', :as => :managing_account
  match 'help/contact-details' => 'site/base#contact_details', :as => :contact_details
  match 'sitemap' => 'site/base#sitemap', :as => :sitemap
  #match 'sitemap.xml' => 'site/base#google_sitemap', :defaults => {:format => :xml}
  match 'wine-franchising' => 'site/base#franchise', :as => :franchise
  match 'enable_disable_chat' => 'admin/base#enable_disable_chat', :as => :enable_disable_chat
  match 'testimonial' => 'site/testimonials#index', :as => :testimonial
  match 'popular' => 'site/base#popular', :as => :popular
  match 'signup' => 'site/customers#new', :as => :signup
  match 'login' => 'site/base#login', :as => :login
  match 'guest_login' => 'site/base#guest_login', :as => :guest_login
  match 'logout' => 'site/base#logout', :as => :logout
  match 'subscribe-dali-news' => 'site/base#subscribe', :as => :subscribe_dali_news
  match 'subscriptions' => 'site/base#create_subscription', :as => :create_subscription, :method => :post
  match 'thank-you' => 'site/base#subscription_complete', :as => :subscription_complete
  match 'unsubscribe-dali-news' => 'site/base#unsubscribe', :as => :unsubscribe_dali_news
  match '/simple_captcha/:action' => 'simple_captcha#index', :as => :simple_captcha
  match 'siteadmin' => 'admin/base#index', :as => :siteadmin
  match 'admin/login' => 'admin/base#login', :as => :admin_login
  match 'blog/:year/:month' => 'site/blog#index', :as => :blog_by_month_page, :year => /\d{4}/, :month => /\d{1,2}/
  match 'orders/:id/invoice' => 'site/orders#invoice', :as => :print_invoice
  match 'my-account' => 'site/customers#account', :as => :account
  match 'follow/:user_id' => 'site/customers#follow', :as => :follow
  match 'unfollow/:user_id' => 'site/customers#unfollow', :as => :unfollow
  match 'grape-guide' => 'site/grapes#index', :as => :grape_guide
  match 'request-new-password' => 'site/customers#request_new_password', :as => :request_new_password
  match 'wine-events' => 'site/categories#show', :as => :wine_events, :category => 'events'
  match 'wine-community' => 'site/forums#index', :as => :wine_community
  match 'grapes/search_results' => 'site/grapes#search_results'

  resources :products, :only => [:index, :show, :wine_of_the_week, :food_of_the_week] do
    resources :reviews, :only => [:new, :create]
    resources :wish_list, :only => [:index, :create, :destroy]
    resources :wine_list, :only => [:index, :create, :destroy]
    resources :cart, :only => [:create, :update, :destroy] do
      collection do
        get :empty
      end
    end
  end


  resources :forums do
    resources :topics do
      resources :posts
      resource :monitorship
    end
  end

  resources :faqs
  resources :news_letters, :only => [:show]
  resources :producers, :only => [:show, :index]
  resources :regions, :only => [:show, :index]
  resources :grapes, :only => [:index, :show]
  resources :wine_lists
  resources :reviews
  resources :messages do
    collection do
    end
  end

  resources :comments
  match "/search" => "site/search#index", :as => "search_index"
  match "/search/find_wines" => "site/search#find_wines", :as => "find_wines"
  match "/search/find_users" => "site/search#find_users", :as => "find_users"
  match "/search/find_producers" => "site/search#find_producers", :as => "find_producers"
  match "/search/find_hampers" => "site/search#find_hampers", :as => "find_hampers"
  match "/search/find_foods" => "site/search#find_foods", :as => "find_foods"
  match "/search/find_recipes" => "site/search#find_recipes", :as => "find_recipes"
  match "/search/find_wine_events" => "site/search#find_wine_events", :as => "find_wine_events"
  match "/search/find_grapes" => "site/search#find_grapes", :as => "find_grapes"
  match 'site/cart/gift_options' => 'site/cart#gift_options'
  match 'site/checkouts/order_confirmation' => 'site/checkouts#order_confirmation'
  match 'site/cart/update_gift' => 'site/cart#update_gift'
  resources :ship_addresses
  resources :checkouts, :only => [:index] do
    collection do
      post :confirm_address
      get :payment
      get :paypal
      get :confirmed
    end
  end

  namespace :site do
    resources :orders, :only => [:index, :new, :create, :show] do
      match :download_pdf, :on => :collection
    end
    resources :wish_list, :only => [:index, :create, :destroy]
    resources :wine_lists, :only => [:index, :create, :destroy]
    resources :reviews
    resources :cart, :only => [:index, :update] do
      collection do
        get :empty
        get :continue_shopping
      end
    end
    resources :cart, :only => [:create, :update, :destroy] do
      collection do
        get :empty
      end
    end
    resources :recipes do
      collection do
        get :recipes_list
      end
    end
    resources :reviews, :only => [:new, :create]
  end

  resources :customers do
    collection do
      get :account
      get :update_default_pic
      get :request_new_password
      post :find
      post :send_message
    end
  end

  match 'site/image' => 'site/images#show', :path_prefix => ':image_type'

  resources :blog, :only => [:index, :show] do
    match :comment, :on => :member
  end

  resources :posts do
    collection do
      post :search
    end
  end

  resources :posts
  match 'admin/products/delete_products_of_the_week' => 'admin/products#delete_products_of_the_week'
  match 'admin/products/products_of_the_week' => 'admin/products#products_of_the_week'
  match 'admin/products/xml' => 'admin/products#xml'
  match 'site/orders/show_order_details' => 'site/orders#show_order_details'
  match 'admin/products/products_sortby_quantity' => 'admin/products#products_sortby_quantity'
  match 'site/orders/review' => 'site/orders#review'
  match 'admin/recipes/xml' => 'admin/recipes#xml'
  match 'admin/xml' => 'admin/xml#index', :as => :xml
  match 'admin/xml/xml_options' => 'admin/xml#xml_options', :as => :xml_options
  match 'admin/xml/eval_xml' => 'admin/xml#eval_xml', :as => :eval_xml
  match 'admin/xml/eval_xml_g_comptible' => 'admin/xml#eval_xml_g_comptible', :as => :eval_xml_g_comptible
  namespace :admin do
    resources :testimonials
    resources :faqs
    resources :shipping_agencies
    resources :occasions
    resources :about_us
    resources :regions do
      resources :images, :only => [:destroy]
    end
    resources :producers do
      resources :images, :only => [:destroy]
    end
    resources :grapes do
      resources :images, :only => [:destroy]
    end
    resources :forums
    resources :categories
    resources :deliveries
    resources :cupons do
      match :product_list, :on => :collection
    end
    resources :forums
    resources :posts
    resources :comments
    match 'admin/comments/approve_comment' => 'admin/comments#approve_comment'
    resources :reviews
    resources :orders, :only => [:index, :show, :destroy] do
      member do
        get :print_tasting
        get :print_invoice
        get :print_picking_list
        get :delivery_details
        get :cancel_delivery_charge
      end
    end
    resources :users
    resources :customers do
      collection do
        get :print_user_details
      end
    end
    resources :gift_options
    resources :subscriptions
    resources :news_letters do
      resources :images, :only => [:destroy]
    end
    resources :recipes do
      resources :images, :only => [:destroy]
      resources :resources, :only => [:destroy]
    end
    resources :resources, :only => [:destroy]
    resources :images, :only => [:destroy]
    resources :products do
      resources :images, :only => [:destroy]
      resources :resources, :only => [:destroy]
    end
    resources :settings, :only => [:index, :update] do
      resources :images, :only => [:destroy]
      resources :resources, :only => [:destroy]
    end
  end

  match 'admin/settings/update_franchise_details' => 'admin/settings#update_franchise_details', :as => :update_franchise_details
  match 'admin/products/:id/meta' => 'admin/products#meta', :as => :product_meta
  match 'admin/products/:id/categories' => 'admin/products#categories', :as => :product_categories
  match 'admin/products/:id/extra' => 'admin/products#extra', :as => :product_extra
  match 'admin/products/:id/ideal_with' => 'admin/products#ideal_with', :as => :product_ideal_with
  match 'admin/products/:id/how_to_cook' => 'admin/products#how_to_cook', :as => :product_how_to_cook
  match 'admin/products/:id/correlation' => 'admin/products#correlation', :as => :product_correlation
  match 'admin/products/:id/images' => 'admin/products#images', :as => :product_images
  match 'admin/products/:id/files' => 'admin/products#files', :as => :product_files
  match 'admin/products/:id/included_products' => 'admin/products#included_products', :as => :included_products
  match 'admin/recipes/:id/meta' => 'admin/recipes#meta', :as => :recipe_meta
  match 'admin/recipes/:id/extra' => 'admin/recipes#extra', :as => :recipe_extra
  match 'admin/recipes/:id/wine' => 'admin/recipes#wine', :as => :recipe_wine
  match 'admin/recipes/:id/correlation' => 'admin/recipes#correlation', :as => :recipe_correlation
  match 'admin/recipes/:id/images' => 'admin/recipes#images', :as => :recipe_images
  match 'admin/recipes/:id/files' => 'admin/recipes#files', :as => :recipe_files
  match 'admin/news_letters/:id/correlation' => 'admin/news_letters#correlation', :as => :news_letter_correlation
  match 'admin/news_letters/:id/images' => 'admin/news_letters#images', :as => :news_letter_images
  match 'wine' => 'site/categories#show', :category => 'wine'
  match 'wine/:category/' => 'site/categories#show_sub', :parent => 'wine'
  match 'wine/all_mixedcase_image/:parent' => 'site/categories#all_mixedcase_image'
  match 'wine/special_offer/:parent' => 'site/categories#special_offer', :parent => 'wine'
  match 'food' => 'site/categories#show', :category => 'food'
  match 'food/:category/' => 'site/categories#show_sub', :parent => 'food'
  match 'food/all_mixedcase_image/:parent' => 'site/categories#all_mixedcase_image'
  match 'food/special_offer/:parent' => 'site/categories#special_offer', :parent => 'food'
  match 'hampers' => 'site/categories#show', :category => 'hampers'
  match 'hampers/:category/' => 'site/categories#show_sub', :parent => 'hampers'
  match 'hampers/all_mixedcase_image/:parent' => 'site/categories#all_mixedcase_image'
  match 'hampers/special_offer/:parent' => 'site/categories#special_offer', :parent => 'hampers'
  match '/wine-tours' => 'site/categories#show', :category => 'wine-tours'
  match '/wine-tours/invite_a_friend' => 'site/products#invite_a_friend', :category => 'wine-tours'
  match '/wine-tours/:id' => 'site/products#show', :category => 'wine-tours'
  match '/wine-events' => 'site/categories#show', :category => 'events'
  match '/wine-events/:id' => 'site/products#show', :category => 'events'
  match '/events' => 'site/categories#show', :category => 'events'
  match '/events/:id' => 'site/products#show', :category => 'events'
  match '/wine-club/' => 'site/categories#show', :category => 'wine-club'
  match '/wine-club/invite_a_friend' => 'site/products#invite_a_friend', :category => 'wine-club'
  match '/wine-club/:id' => 'site/products#show', :category => 'wine-club'
  match '/:root_category/:category/:id' => 'site/products#show', :as => :nested_products
  match '/:category/:id' => 'site/products#show', :as => :nested_product
  match '/:parent_category/:sub_category/' => 'site/products#index', :as => :nested_categories
  match '/:controller(/:action(/:id))'
  match '*path' => 'site/base#index'
  root :to => 'site/base#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
