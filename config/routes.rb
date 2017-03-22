ItalyabroadNew::Application.routes.draw do
  namespace :admin do
    resources :testimonials
    resources :faqs
    resources :shipping_agencies
    resources :occasions
    resources :about_us
    resources :contact_messages
    resources :regions do
      resources :images, :only => [:destroy]
    end
    resources :producers  do
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
    resources :reviews do
      match :send_mails, :on => :collection
    end
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
      collection do 
        get 'xml'
      end
      resources :images, :only => [:destroy]
      resources :resources, :only => [:destroy]
    end
    resources :resources, :only => [:destroy]
    resources :images, :only => [:destroy]
    resources :products do
       collection do 
          get 'xml'
        end
      resources :images, :only => [:destroy]
      resources :resources, :only => [:destroy]
    end
    resources :settings, :only => [:index, :update] do
      
      collection do 
        get 'available_backups'
        get 'restore'
        get 'take_backup_now'
        get 'download'

      end

      resources :images, :only => [:destroy]
      resources :resources, :only => [:destroy]
    end
    resources :small_box_settings 
    get "moods/index"

    get "moods/new"

    post "moods/create"

    get "moods/edit"

    put "moods/update"
    delete "moods/destroy"
  end



  get "moods/index"

  resources :chat_messages do
    collection do
      get "take_username" => "chat_messages#take_username"
    end
  end

  namespace(:admin){
    resources :wine_sizes
    resources :sommeliers
    resources :food_or_drinks
    resources :desired_expenditures
    resources :food_options
    resources :manage_sommeliers, :only => [:index, :create]
  }

  # namespace(:site){ resources :authentications }

  match "/auth/:provider/callback" => "site/authentications#create"
  #match "/signout" => "site/sessions#destroy", :as => :signout

  #match '/auth/:provider/callback' => 'authentications#create'

  match 'suppliers' => 'site/base#supplier', :as => :meet_us
  match 'contact-us' => 'site/base#contact', :as => :contact_us
  match 'corporate-services' => 'site/base#corporate', :as => :corporate
  match 'wholesale-enquiry' => 'site/base#enquiries', :as => :wholesale_enquiry
  match 'about-us' => 'site/base#about_us', :as => :about_us
  match 'our-manifesto' => 'site/base#our_principles', :as => :our_principles
  match 'meet-us' => 'site/base#meet_us', :as => :meet_us
  match 'terms-and-conditions' => 'site/base#conditions', :as => :terms_and_conditions
  match 'privacy-policy' => 'site/base#privacy', :as => :privacy_policy
  match 'delivery-services' => 'site/base#delivery_services', :as => :delivery_services
  match 'managing-account' => 'site/base#managing_account', :as => :managing_account
  match 'contact-details' => 'site/base#contact_details', :as => :contact_details
  match 'sitemap' => 'site/base#sitemap', :as => :sitemap
  match 'google_sitemap.xml' => 'site/base#google_sitemap', :defaults => {:format => :xml}
  match 'guarantee_of_satisfaction' => 'site/base#guarantee_of_satisfaction', :as => :guarantee_of_satisfaction
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
  #match '/simple_captcha/:action' => 'simple_captcha#index', :as => :simple_captcha
  match 'simple_captcha/:id', :to => 'simple_captcha#show', :as => :simple_captcha
  match 'siteadmin' => 'admin/base#index', :as => :siteadmin
  match 'admin/login' => 'admin/base#login', :as => :admin_login
  get '/site/blog/:friendly_identifier' => 'site/blog#show'
  
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
  get '/landing.html'=> 'site/base#landing_page'
  get '/messages/send_reply'=> 'site/messages#send_reply'
  post '/messages/send_message' => 'site/messages#send_message'
#-- TO DO Remove these blocks if url run correctly---------------------------------------
  # ------- write action and view but not call------------------------------------------------
    # resources :products, :only => [:index, :show, :wine_of_the_week, :food_of_the_week] do
    #       resources :reviews, :only => [:new, :create]
    #       resources :wine_list, :only => [:index, :create, :destroy]
    #       resources :wish_list, :only => [:index, :create, :destroy]
    #       resources :cart, :only => [:create, :update, :destroy] do
    #         collection do
    #           get :empty
    #         end
    #       end
    #     end

    #   resources :forums do
    #     resources :topics do
    #       resources :posts
    #       resource :monitorship
    #     end
    #   end
  #-------------------------------------NOT USED-----------------------------------------
    # resources :wine_lists 
    # resources :reviews
    # resources :messages do
    #   collection do
    #   end
    # end

    # resources :comments
  #-------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
  # match "/search" => "site/search#index", :as => "search_index"
  # match "/search/find_wines" => "site/search#find_wines", :as => "find_wines"
  # match "/search/find_other_drinks" => "site/search#find_other_drinks", :as => "find_other_drinks"
  # match "/search/find_users" => "site/search#find_users", :as => "find_users"
  # match "/search/find_producers" => "site/search#find_producers", :as => "find_producers"
  # match "/search/find_hampers" => "site/search#find_hampers", :as => "find_hampers"
  # match "/search/find_foods" => "site/search#find_foods", :as => "find_foods"
  # match "/search/find_recipes" => "site/search#find_recipes", :as => "find_recipes"
  # match "/search/find_wine_events" => "site/search#find_wine_events", :as => "find_wine_events"
  # match "/search/find_grapes" => "site/search#find_grapes", :as => "find_grapes"

  match 'cart/gift_options' => 'site/cart#gift_options'
  match 'checkouts/order_confirmation' => 'site/checkouts#order_confirmation'
  match 'cart/update_gift' => 'site/cart#update_gift'

  scope module: 'site' do  
     #------------ not_use But genrate for save hand ------------------------------------------
      resources :products, :only => [:index, :show, :wine_of_the_week, :food_of_the_week] do
        resources :reviews, :only => [:new, :create]
        resources :wine_list, :only => [:index, :create, :destroy]
        resources :wish_list, :only => [:index, :create, :destroy]
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
    # -----------------------------------------------------------------------------------------
    resources :authentications
    resources :search, :only => [:index] do
      collection do 
        get :find_wines
        get :find_other_drinks
        get :find_users
        get :find_producers
        get :find_hampers
        get :find_foods
        get :find_recipes
        get :find_wine_events
        get :find_grapes
        get :autocomplete_search_name
        get :autocomplete_search_wine_name
        get :autocomplete_search_food_name
        get :autocomplete_search_hamper_name
        get :autocomplete_search_drinks_name
        get :autocomplete_post_name
        get :autocomplete_search_recipes_name
      end
    end
    
  
    resources :orders, :only => [:index, :new, :create, :show] do
      member do
        get :cancel_review
      end
      match :download_pdf, :on => :collection
    end
    resources :wish_list, :only => [:index, :create, :destroy]
    resources :wine_lists, :only => [:index, :create, :destroy]
    resources :reviews
    resources :cart, :only => [:index, :update] do
      collection do
        get :empty
        get :continue_shopping
        get :user_select
        post :user_select
      end
    end
    resources :cart, :only => [:create, :update, :destroy] do
      get :autocomplete_user_name, :on => :collection
      collection do
        get :empty
        get "gift_options"
      end
    end
    resources :recipes do
      collection do
        get :recipes_list
      end
    end
    resources :reviews, :only => [:new, :create]
    resources :blog, :only => [:index, :show] do
      match :comment, :on => :member
    end

    resources :producers , :only => [:show, :index]
    resources :grapes, :only => [:index, :show]
    resources :faqs
    resources :customers do
      collection do
        get :account
        get :update_default_pic
        get :request_new_password
        post :find
        post :send_message
      end
    end
    resources :products, :only => [:show]
    resources :regions, :only => [:show, :index]
    resources :checkouts, :only => [:index] do
      collection do
        post :confirm_address
        get :payment
        get :paypal
        get :confirmed
      end
    end
    resources :news_letters, :only => [:show]
    resources :ship_addresses
    resources :chat do
      match :create_chat_user, :on => :collection
      match :send_data, :on => :collection
      match :send_message, :on => :collection, :via => :post
    end
    resources :sommelier
    resources :moods, :only => :index
  end

  match 'image' => 'site/images#show', :path_prefix => ':image_type'
  resources :image, :controller => 'site/images', :only => [:show], :path_prefix => ':image_type'

  resources :posts do
    collection do
      post :search
    end
  end

  resources :posts
  match 'admin/products/delete_products_of_the_week' => 'admin/products#delete_products_of_the_week'
  match 'admin/products/products_of_the_week' => 'admin/products#products_of_the_week'
  match '/show_order_details' => 'site/orders#show_order_details'
  match 'admin/products/products_sortby_quantity' => 'admin/products#products_sortby_quantity'
  match 'orders/review' => 'site/orders#review'
  match 'admin/xml' => 'admin/xml#index', :as => :xml
  match 'admin/xml/xml_options' => 'admin/xml#xml_options', :as => :xml_options
  match 'admin/xml/eval_xml' => 'admin/xml#eval_xml', :as => :eval_xml
  match 'admin/xml/eval_xml_g_comptible' => 'admin/xml#eval_xml_g_comptible', :as => :eval_xml_g_comptible
  match 'admin/comments/:id/approve_comment' => 'admin/comments#approve_comment', as: 'approve_comment'


  match 'admin/settings/update_guarantee_of_satisfaction_details' => 'admin/settings#update_guarantee_of_satisfaction_details', :as => :update_guarantee_of_satisfaction_details
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
  match 'other-drinks/:category/' => 'site/categories#show_sub', :parent => 'other-drinks'
  match 'wine/all_mixedcase_image/:parent' => 'site/categories#all_mixedcase_image'
  match 'wine/special_offer/:parent' => 'site/categories#special_offer', :parent => 'wine'
  match 'food' => 'site/categories#show', :category => 'food'
  match 'food/:category/' => 'site/categories#show_sub', :parent => 'food'
  match 'food/all_mixedcase_image/:parent' => 'site/categories#all_mixedcase_image'
  match 'food/special_offer/:parent' => 'site/categories#special_offer', :parent => 'food'
  match 'hampers' => 'site/categories#show', :category => 'hampers'
  match 'hampers/:id/' => 'site/products#show', :parent => 'hampers'
  match 'hampers/all_mixedcase_image/:parent' => 'site/categories#all_mixedcase_image'
  match 'hampers/special_offer/:parent' => 'site/categories#special_offer', :parent => 'hampers'
  match '/wine-tours' => 'site/categories#show', :category => 'wine-tours'
  match '/other-drinks' => 'site/categories#show', :category => 'other-drinks'
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
  # match '*path' => 'site/base#index'
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
