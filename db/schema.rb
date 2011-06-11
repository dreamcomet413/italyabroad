# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110611083408) do

  create_table "about_us", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "link_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "image_id"
  end

  create_table "attribute_items", :force => true do |t|
    t.string "name"
    t.string "section"
  end

  create_table "attribute_sets", :force => true do |t|
    t.string "name"
  end

  create_table "attributions", :force => true do |t|
    t.integer "attribute_item_id"
    t.integer "attribute_set_id"
  end

  create_table "blog_types", :force => true do |t|
    t.string "name"
  end

  create_table "categories", :force => true do |t|
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.string  "title"
    t.string  "name"
    t.text    "description"
    t.integer "image_id"
    t.string  "meta_key"
    t.text    "meta_description"
    t.string  "key_1"
    t.string  "key_2"
    t.string  "key_3"
    t.string  "layout"
    t.string  "layout_search"
    t.string  "layout_card"
    t.string  "layout_image"
    t.boolean "show_in_menu",        :default => true
    t.boolean "show_in_boxes",       :default => true
    t.string  "image_url"
    t.string  "friendly_identifier"
    t.string  "text_on_image"
    t.string  "page_heading"
  end

  create_table "categorizations", :force => true do |t|
    t.integer "product_id"
    t.integer "category_id"
  end

  create_table "comments", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "web_site"
    t.integer  "user_id"
    t.text     "description"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mail_check",  :default => false
  end

  create_table "cupons", :force => true do |t|
    t.string  "code"
    t.integer "price"
    t.integer "min_order"
    t.boolean "active",     :default => true
    t.integer "product_id"
    t.boolean "public"
    t.string  "cupon_type", :default => "price"
  end

  create_table "cupons_products", :force => true do |t|
    t.integer "cupon_id"
    t.integer "product_id"
  end

  create_table "deliveries", :force => true do |t|
    t.string  "name"
    t.decimal "price", :precision => 8, :scale => 2, :default => 0.0
  end

  create_table "faqs", :force => true do |t|
    t.string   "question",                      :null => false
    t.text     "answer"
    t.integer  "user_id"
    t.boolean  "publish",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_posts", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.integer  "topic_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",         :default => 0
    t.integer  "sticky",       :default => 0
    t.datetime "replied_at"
    t.boolean  "locked",       :default => false
    t.integer  "replied_by"
    t.integer  "last_post_id"
    t.text     "body"
    t.text     "body_html"
  end

  add_index "forum_posts", ["forum_id", "created_at"], :name => "index_posts_on_forum_id"
  add_index "forum_posts", ["topic_id", "created_at"], :name => "index_posts_on_topic_id"
  add_index "forum_posts", ["user_id", "created_at"], :name => "index_posts_on_user_id"

  create_table "forums", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "topics_count",     :default => 0
    t.integer "posts_count",      :default => 0
    t.integer "position"
    t.text    "description_html"
  end

  create_table "gift_options", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.decimal "price",       :precision => 8, :scale => 2, :default => 0.0
    t.boolean "is_default",                                :default => false
  end

  create_table "grapes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "friendly_identifier"
  end

  create_table "grapes_producers", :id => false, :force => true do |t|
    t.integer "grape_id"
    t.integer "producer_id"
  end

  create_table "images", :force => true do |t|
    t.string  "image_filename"
    t.integer "image_width"
    t.integer "image_height"
  end

  create_table "menus", :force => true do |t|
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.string  "name"
    t.string  "controller"
    t.string  "action"
  end

  create_table "messages", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "send_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moderatorships", :force => true do |t|
    t.integer "forum_id"
    t.integer "user_id"
  end

  add_index "moderatorships", ["forum_id"], :name => "index_moderatorships_on_forum_id"

  create_table "monitorships", :force => true do |t|
    t.integer "topic_id"
    t.integer "user_id"
    t.boolean "active",   :default => true
  end

  create_table "news_letter_types", :force => true do |t|
    t.string "name"
  end

  create_table "news_letters", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "news_letter_type_id"
    t.boolean  "customers",             :default => true
    t.boolean  "subscribers",           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status_news_letter_id"
    t.integer  "image_1_id"
    t.integer  "image_2_id"
    t.integer  "image_3_id"
    t.integer  "image_4_id"
    t.integer  "image_5_id"
    t.integer  "image_6_id"
    t.string   "link_1"
    t.string   "link_2"
    t.string   "link_3"
    t.string   "link_4"
    t.string   "link_5"
    t.string   "link_6"
    t.integer  "header_id"
    t.integer  "image_7_id"
    t.string   "link_7"
    t.integer  "image_8_id"
    t.string   "link_8"
  end

  create_table "news_letters_products", :force => true do |t|
    t.integer "news_letter_id"
    t.integer "product_id"
  end

  create_table "occasions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_items", :force => true do |t|
    t.string  "name"
    t.decimal "price",        :precision => 8, :scale => 2, :default => 0.0
    t.string  "rate"
    t.decimal "vat",          :precision => 8, :scale => 2, :default => 0.0
    t.integer "quantity"
    t.integer "order_id"
    t.string  "product_code"
    t.integer "product_id"
    t.boolean "reviewed",                                   :default => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "status_order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note"
    t.string   "cupon_code"
    t.decimal  "cupon_price",                :precision => 8, :scale => 2, :default => 0.0
    t.boolean  "paid",                                                     :default => false
    t.string   "delivery_name"
    t.decimal  "delivery_price",             :precision => 8, :scale => 2, :default => 0.0
    t.integer  "payment_method_id"
    t.boolean  "different_shipping_address",                               :default => false
    t.string   "ship_name"
    t.string   "ship_address"
    t.string   "ship_address_2"
    t.string   "ship_city"
    t.string   "ship_cap"
    t.string   "ship_country"
    t.boolean  "ship_a_gift",                                              :default => false
    t.integer  "gift_option_id"
    t.text     "gift_note"
    t.string   "ship_telephone"
    t.integer  "shipping_agency_id"
    t.string   "consignment_no"
    t.float    "points_used",                                              :default => 0.0,   :null => false
  end

  create_table "payment_methods", :force => true do |t|
    t.string  "name"
    t.string  "vendor"
    t.string  "password"
    t.boolean "external", :default => false
  end

  create_table "photos", :force => true do |t|
    t.string   "image_filename"
    t.integer  "image_width"
    t.integer  "image_height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "draft",          :default => true
  end

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.string   "page_title"
    t.string   "meta_keys"
    t.text     "meta_description"
    t.integer  "blog_type_id"
    t.integer  "image_1_id"
    t.integer  "image_2_id"
    t.integer  "image_3_id"
    t.integer  "resource_1_id"
    t.integer  "resource_2_id"
    t.integer  "resource_3_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description_short"
    t.text     "description"
    t.string   "friendly_identifier"
    t.integer  "view_count",          :default => 0
  end

  create_table "posts_tags", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  create_table "producers", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
    t.string   "friendly_identifier"
    t.integer  "image_id"
  end

  create_table "producers_products", :force => true do |t|
    t.integer "producer_id"
    t.integer "product_id"
  end

  create_table "product_correlations", :force => true do |t|
    t.integer "product_id"
    t.integer "correlation_id"
  end

  create_table "product_includeds", :force => true do |t|
    t.integer  "product_id"
    t.integer  "included_product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.text     "description_short"
    t.text     "description"
    t.decimal  "price",               :precision => 8, :scale => 2, :default => 0.0
    t.string   "rate",                                              :default => "17.5%"
    t.decimal  "cost",                :precision => 8, :scale => 2, :default => 0.0
    t.integer  "image_1_id"
    t.integer  "image_2_id"
    t.integer  "image_3_id"
    t.integer  "resource_1_id"
    t.integer  "resource_2_id"
    t.integer  "resource_3_id"
    t.boolean  "active",                                            :default => true
    t.integer  "quantity",                                          :default => 1
    t.boolean  "raccomanded",                                       :default => false
    t.string   "region"
    t.boolean  "vegetarian",                                        :default => false
    t.boolean  "organic",                                           :default => false
    t.string   "color"
    t.string   "size"
    t.string   "weight"
    t.string   "page_title"
    t.string   "meta_keys"
    t.text     "meta_description"
    t.integer  "better_together"
    t.boolean  "upselling"
    t.boolean  "comments"
    t.boolean  "say_to_friend"
    t.boolean  "review"
    t.string   "vintage"
    t.string   "volume"
    t.integer  "rating"
    t.integer  "from_quantity",                                     :default => 0
    t.decimal  "from_quantity_price", :precision => 8, :scale => 2, :default => 0.0
    t.string   "date_arrival"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "how_to_cook_id"
    t.integer  "ideal_with_id"
    t.decimal  "discount",            :precision => 8, :scale => 2, :default => 0.0
    t.datetime "date"
    t.string   "friendly_identifier"
    t.boolean  "featured",                                          :default => false
    t.integer  "region_id"
    t.integer  "producer_id"
    t.integer  "occasion_id",                                       :default => 0
  end

  create_table "products_grapes", :force => true do |t|
    t.integer  "product_id"
    t.integer  "grape_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", :force => true do |t|
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipe_correlations", :force => true do |t|
    t.integer "product_id"
    t.integer "recipe_id"
  end

  create_table "recipe_levels", :force => true do |t|
    t.string "name"
  end

  create_table "recipe_types", :force => true do |t|
    t.string "name"
  end

  create_table "recipes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "preparation_time"
    t.text     "ingredients"
    t.text     "preparation"
    t.integer  "product_id"
    t.integer  "recipe_level_id"
    t.integer  "recipe_type_id"
    t.string   "page_title"
    t.string   "meta_keys"
    t.text     "meta_description"
    t.integer  "image_1_id"
    t.integer  "image_2_id"
    t.integer  "image_3_id"
    t.integer  "resource_1_id"
    t.integer  "resource_2_id"
    t.integer  "resource_3_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "raccomanded",         :default => false
    t.integer  "rating"
    t.boolean  "active",              :default => false
    t.string   "friendly_identifier"
    t.integer  "view_count",          :default => 0
    t.integer  "user_id"
    t.string   "serves"
    t.boolean  "vegetarian",          :default => false
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "friendly_identifier"
    t.integer  "image_id"
  end

  create_table "reservations", :force => true do |t|
    t.integer  "restaurant_id"
    t.integer  "user_id"
    t.integer  "status_reservation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
  end

  create_table "resources", :force => true do |t|
    t.integer "size"
    t.string  "content_type"
    t.string  "filename"
  end

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.string   "lunch"
    t.string   "dinner"
    t.string   "weekend_lunch"
    t.string   "weekend_dinner"
    t.string   "reservation"
    t.integer  "cost",               :default => 0
    t.string   "closed"
    t.text     "happy_hour"
    t.text     "regional_cuisine"
    t.text     "address"
    t.text     "description"
    t.boolean  "online_reservation"
    t.string   "page_title"
    t.string   "meta_keys"
    t.text     "meta_description"
    t.integer  "image_1_id"
    t.integer  "image_2_id"
    t.integer  "image_3_id"
    t.integer  "resource_1_id"
    t.integer  "resource_2_id"
    t.integer  "resource_3_id"
    t.string   "telephone"
    t.string   "fax"
    t.string   "mobile"
    t.string   "email"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "google_map_link"
    t.boolean  "raccomanded",        :default => false
    t.integer  "rating"
    t.string   "city"
    t.string   "cap"
    t.string   "style"
    t.boolean  "active",             :default => false
  end

  create_table "reviews", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "reviewer_id"
    t.string   "reviewer_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score"
    t.boolean  "publish",       :default => false
  end

  create_table "schemaInfo", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "search_queries", :force => true do |t|
    t.string   "query"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.integer "wine_pdf_id"
    t.decimal "order_amount",          :precision => 8, :scale => 2, :default => 0.0
    t.decimal "order_cupon_amount",    :precision => 8, :scale => 2, :default => 0.0
    t.decimal "order_delivery_amount", :precision => 8, :scale => 2, :default => 0.0
    t.integer "home_image_1_id"
    t.string  "home_image_1_url"
    t.integer "home_image_2_id"
    t.integer "home_image_3_id"
    t.integer "home_image_4_id"
    t.string  "home_image_2_url"
    t.string  "home_image_3_url"
    t.string  "home_image_4_url"
    t.string  "home_image_1_title"
    t.string  "home_image_2_title"
    t.string  "home_image_3_title"
    t.string  "home_image_4_title"
    t.integer "home_image_5_id"
    t.string  "home_image_5_title"
    t.string  "home_image_5_url"
    t.string  "promotion"
    t.integer "reorder_quantity"
    t.string  "vat_rate",                                            :default => "0.00"
    t.string  "support",                                             :default => "admin"
    t.float   "points_per_pound",                                    :default => 0.0,     :null => false
    t.float   "points_to_pound",                                     :default => 0.0,     :null => false
    t.string  "desc_wine_of_the_week"
    t.string  "desc_food_of_the_week"
    t.string  "producer_page_quote"
  end

  create_table "ship_addresses", :force => true do |t|
    t.string  "code"
    t.string  "name"
    t.string  "telephone"
    t.string  "address"
    t.string  "address_2"
    t.string  "city"
    t.string  "cap"
    t.string  "country"
    t.text    "note"
    t.integer "user_id"
  end

  create_table "shipping_agencies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.string   "sluggable_type"
    t.integer  "sluggable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "status_news_letters", :force => true do |t|
    t.string "name"
  end

  create_table "status_orders", :force => true do |t|
    t.string "name"
  end

  create_table "status_reservations", :force => true do |t|
    t.string "name"
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "know_through"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.text     "body_html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",         :default => 0
    t.integer  "sticky",       :default => 0
    t.integer  "posts_count",  :default => 0
    t.datetime "replied_at"
    t.boolean  "locked",       :default => false
    t.integer  "replied_by"
    t.integer  "last_post_id"
  end

  add_index "topics", ["forum_id", "replied_at"], :name => "index_topics_on_forum_id_and_replied_at"
  add_index "topics", ["forum_id", "sticky", "replied_at"], :name => "index_topics_on_sticky_and_replied_at"
  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"

  create_table "types", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "name"
    t.string   "surname"
    t.string   "address"
    t.string   "address_no"
    t.string   "city"
    t.string   "province"
    t.string   "cap"
    t.text     "note"
    t.string   "telephone"
    t.string   "mobile"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.boolean  "active",                                   :default => false
    t.boolean  "activation_sent",                          :default => false
    t.integer  "type_id"
    t.string   "country"
    t.string   "activation_code"
    t.string   "know_through"
    t.string   "title"
    t.string   "address_2"
    t.boolean  "news_letters",                             :default => true
    t.boolean  "ship_a_gift",                              :default => false
    t.string   "friend_name"
    t.string   "friend_email",                             :default => "If Known"
    t.date     "dob"
    t.integer  "posts_count",                              :default => 0
    t.datetime "last_seen_at"
    t.integer  "photo_id"
    t.string   "photo_default"
    t.string   "holidays"
    t.string   "songs"
    t.string   "films"
    t.string   "newspapers"
    t.string   "chef_bio"
    t.string   "establishment_link"
    t.string   "fav_meals",                 :limit => 100
    t.string   "fav_wine",                  :limit => 100
  end

  create_table "week_products", :force => true do |t|
    t.integer  "week_product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wine_lists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wish_lists", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "quantity",   :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
