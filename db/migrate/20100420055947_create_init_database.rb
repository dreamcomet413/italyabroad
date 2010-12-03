class CreateInitDatabase < ActiveRecord::Migration
  def self.up
    create_table :product_correlations do |t|
      t.column :product_id, :integer, :limit => 10
      t.column :correlation_id, :integer, :limit => 10
    end
    create_table :wish_lists do |t|
      t.column :user_id, :integer, :limit => 10
      t.column :product_id, :integer, :limit => 10
      t.column :quantity, :integer, :limit => 10, :default => 1
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    create_table :posts do |t|
      t.column :name, :string, :limit => 255
      t.column :page_title, :string, :limit => 255
      t.column :meta_keys, :string, :limit => 255
      t.column :meta_description, :text
      t.column :blog_type_id, :integer, :limit => 10
      t.column :image_1_id, :integer, :limit => 10
      t.column :image_2_id, :integer, :limit => 10
      t.column :image_3_id, :integer, :limit => 10
      t.column :resource_1_id, :integer, :limit => 10
      t.column :resource_2_id, :integer, :limit => 10
      t.column :resource_3_id, :integer, :limit => 10
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :description_short, :text
      t.column :description, :text
    end
    create_table :attribute_items do |t|
      t.column :name, :string, :limit => 255
      t.column :section, :string, :limit => 255
    end
    create_table :products do |t|
      t.column :name, :string, :limit => 255
      t.column :code, :string, :limit => 255
      t.column :description_short, :text
      t.column :description, :text
      t.column :price, :float, :default => '0.00'
      t.column :rate, :string, :limit => 255, :default => '17.5%'
      t.column :cost, :float, :default => '0.00'
      t.column :image_1_id, :integer, :limit => 10
      t.column :image_2_id, :integer, :limit => 10
      t.column :image_3_id, :integer, :limit => 10
      t.column :resource_1_id, :integer, :limit => 10
      t.column :resource_2_id, :integer, :limit => 10
      t.column :resource_3_id, :integer, :limit => 10
      t.column :active, :string, :default => '1'
      t.column :quantity, :integer, :limit => 10, :default => 1
      t.column :raccomanded, :string, :default => '0'
      t.column :region, :string, :limit => 255
      t.column :grape_color_1, :string, :limit => 255
      t.column :vegetarian, :string, :default => '0'
      t.column :organic, :string, :default => '0'
      t.column :color, :string, :limit => 255
      t.column :size, :string, :limit => 255
      t.column :weight, :string, :limit => 255
      t.column :page_title, :string, :limit => 255
      t.column :meta_keys, :string, :limit => 255
      t.column :meta_description, :text
      t.column :better_together, :integer, :limit => 10
      t.column :upselling, :string
      t.column :comments, :string
      t.column :say_to_friend, :string
      t.column :review, :string
      t.column :vintage, :string, :limit => 255
      t.column :volume, :string, :limit => 255
      t.column :rating, :integer, :limit => 10
      t.column :from_quantity, :integer, :limit => 10, :default => 0
      t.column :from_quantity_price, :float, :default => '0.00'
      t.column :date_arrival, :string, :limit => 255
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :how_to_cook_id, :integer, :limit => 10
      t.column :ideal_with_id, :integer, :limit => 10
      t.column :discount, :float, :default => '0.00'
      t.column :grape_color_2, :string, :limit => 255
      t.column :grape_color_3, :string, :limit => 255
      t.column :grape_color_4, :string, :limit => 255
      t.column :grape_color_5, :string, :limit => 255
      t.column :grape_color_6, :string, :limit => 255
      t.column :date, :datetime
      t.column :producer_name, :string, :limit => 255
      t.column :producer_desc, :text
      t.column :friendly_identifier, :string, :limit => 255
    end
    create_table :users do |t|
      t.column :login, :string, :limit => 255
      t.column :name, :string, :limit => 255
      t.column :surname, :string, :limit => 255
      t.column :address, :string, :limit => 255
      t.column :address_no, :string, :limit => 255
      t.column :city, :string, :limit => 255
      t.column :province, :string, :limit => 255
      t.column :cap, :string, :limit => 255
      t.column :note, :text
      t.column :telephone, :string, :limit => 255
      t.column :mobile, :string, :limit => 255
      t.column :email, :string, :limit => 255
      t.column :crypted_password, :string, :limit => 40
      t.column :salt, :string, :limit => 40
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :remember_token, :string, :limit => 255
      t.column :remember_token_expires_at, :datetime
      t.column :active, :string, :default => '0'
      t.column :activation_sent, :string, :default => '0'
      t.column :type_id, :integer, :limit => 10
      t.column :country, :string, :limit => 255
      t.column :activation_code, :string, :limit => 255
      t.column :know_through, :string, :limit => 255
      t.column :title, :string, :limit => 255
      t.column :address_2, :string, :limit => 255
      t.column :news_letters, :string, :default => '1'
      t.column :ship_a_gift, :string, :default => '0'
      t.column :friend_name, :string, :limit => 255
      t.column :friend_email, :string, :limit => 255, :default => 'If Known'
      t.column :dob, :date
    end
    create_table :payment_methods do |t|
      t.column :name, :string, :limit => 255
      t.column :vendor, :string, :limit => 255
      t.column :password, :string, :limit => 255
      t.column :external, :string, :default => '0'
    end
    create_table :attribute_sets do |t|
      t.column :name, :string, :limit => 255
    end
    create_table :recipe_correlations do |t|
      t.column :product_id, :integer, :limit => 10
      t.column :recipe_id, :integer, :limit => 10
    end
    create_table :types do |t|
      t.column :name, :string, :limit => 255
    end
    create_table :orders do |t|
      t.column :user_id, :integer, :limit => 10
      t.column :status_order_id, :integer, :limit => 10
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :note, :text
      t.column :cupon_code, :string, :limit => 255
      t.column :cupon_price, :float, :default => '0.00'
      t.column :paid, :string, :default => '0'
      t.column :delivery_name, :string, :limit => 255
      t.column :delivery_price, :float, :default => '0.00'
      t.column :payment_method_id, :integer, :limit => 10
      t.column :different_shipping_address, :string, :default => '0'
      t.column :ship_name, :string, :limit => 255
      t.column :ship_address, :string, :limit => 255
      t.column :ship_address_2, :string, :limit => 255
      t.column :ship_city, :string, :limit => 255
      t.column :ship_cap, :string, :limit => 255
      t.column :ship_country, :string, :limit => 255
      t.column :ship_a_gift, :string, :default => '0'
      t.column :gift_option_id, :integer, :limit => 10
      t.column :gift_note, :text
      t.column :ship_telephone, :string, :limit => 255
    end
    create_table :attributions do |t|
      t.column :attribute_item_id, :integer, :limit => 10
      t.column :attribute_set_id, :integer, :limit => 10
    end
    create_table :recipe_levels do |t|
      t.column :name, :string, :limit => 255
    end
    create_table :subscriptions do |t|
      t.column :name, :string, :limit => 255
      t.column :surname, :string, :limit => 255
      t.column :email, :string, :limit => 255
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :know_through, :string, :limit => 255
    end
    create_table :order_items do |t|
      t.column :name, :string, :limit => 255
      t.column :price, :float, :default => '0.00'
      t.column :rate, :string, :limit => 255
      t.column :vat, :float, :default => '0.00'
      t.column :quantity, :integer, :limit => 10
      t.column :order_id, :integer, :limit => 10
      t.column :product_code, :string, :limit => 255
      t.column :product_id, :integer, :limit => 10
    end
    create_table :blog_types do |t|
      t.column :name, :string, :limit => 255
    end
    create_table :recipe_types do |t|
      t.column :name, :string, :limit => 255
    end
    create_table :categories do |t|
      t.column :parent_id, :integer, :limit => 10
      t.column :lft, :integer, :limit => 10
      t.column :rgt, :integer, :limit => 10
      t.column :title, :string, :limit => 255
      t.column :name, :string, :limit => 255
      t.column :description, :text
      t.column :image_id, :integer, :limit => 10
      t.column :meta_key, :string, :limit => 255
      t.column :meta_description, :text
      t.column :key_1, :string, :limit => 255
      t.column :key_2, :string, :limit => 255
      t.column :key_3, :string, :limit => 255
      t.column :layout, :string, :limit => 255
      t.column :layout_search, :string, :limit => 255
      t.column :layout_card, :string, :limit => 255
      t.column :layout_image, :string, :limit => 255
      t.column :show_in_menu, :string, :default => '1'
      t.column :show_in_boxes, :string, :default => '1'
      t.column :image_url, :string, :limit => 255
      t.column :friendly_identifier, :string, :limit => 255
    end
    create_table :recipes do |t|
      t.column :name, :string, :limit => 255
      t.column :description, :text
      t.column :preparation_time, :integer, :limit => 10
      t.column :ingredients, :text
      t.column :preparation, :text
      t.column :product_id, :integer, :limit => 10
      t.column :recipe_level_id, :integer, :limit => 10
      t.column :recipe_type_id, :integer, :limit => 10
      t.column :page_title, :string, :limit => 255
      t.column :meta_keys, :string, :limit => 255
      t.column :meta_description, :text
      t.column :image_1_id, :integer, :limit => 10
      t.column :image_2_id, :integer, :limit => 10
      t.column :image_3_id, :integer, :limit => 10
      t.column :resource_1_id, :integer, :limit => 10
      t.column :resource_2_id, :integer, :limit => 10
      t.column :resource_3_id, :integer, :limit => 10
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :raccomanded, :string, :default => '0'
      t.column :rating, :integer, :limit => 10
      t.column :active, :string, :default => '0'
      t.column :friendly_identifier, :string, :limit => 255
    end
    create_table :status_orders do |t|
      t.column :name, :string, :limit => 255
    end
    create_table :news_letters_products do |t|
      t.column :news_letter_id, :integer, :limit => 10
      t.column :product_id, :integer, :limit => 10
    end
    create_table :categorizations do |t|
      t.column :product_id, :integer, :limit => 10
      t.column :category_id, :integer, :limit => 10
    end
    create_table :status_news_letters do |t|
      t.column :name, :string, :limit => 255
    end
    create_table :news_letters do |t|
      t.column :name, :string, :limit => 255
      t.column :description, :text
      t.column :news_letter_type_id, :integer, :limit => 10
      t.column :customers, :string, :default => '1'
      t.column :subscribers, :string, :default => '1'
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :status_news_letter_id, :string, :limit => 255
      t.column :image_1_id, :integer, :limit => 10
      t.column :image_2_id, :integer, :limit => 10
      t.column :image_3_id, :integer, :limit => 10
      t.column :image_4_id, :integer, :limit => 10
      t.column :image_5_id, :integer, :limit => 10
      t.column :image_6_id, :integer, :limit => 10
      t.column :link_1, :string, :limit => 255
      t.column :link_2, :string, :limit => 255
      t.column :link_3, :string, :limit => 255
      t.column :link_4, :string, :limit => 255
      t.column :link_5, :string, :limit => 255
      t.column :link_6, :string, :limit => 255
      t.column :header_id, :integer, :limit => 10
      t.column :image_7_id, :integer, :limit => 10
      t.column :link_7, :string, :limit => 255
      t.column :image_8_id, :integer, :limit => 10
      t.column :link_8, :string, :limit => 255
    end
    create_table :comments do |t|
      t.column :name, :string, :limit => 255
      t.column :email, :string, :limit => 255
      t.column :web_site, :string, :limit => 255
      t.column :user_id, :integer, :limit => 10
      t.column :description, :text
      t.column :post_id, :integer, :limit => 10
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    create_table :resources do |t|
      t.column :size, :integer, :limit => 10
      t.column :content_type, :string, :limit => 255
      t.column :filename, :string, :limit => 255
    end
    create_table :slugs do |t|
      t.column :name, :string, :limit => 255
      t.column :sluggable_type, :string, :limit => 255
      t.column :sluggable_id, :integer, :limit => 10
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    create_table :news_letter_types do |t|
      t.column :name, :string, :limit => 255
    end
    create_table :cupons do |t|
      t.column :code, :string, :limit => 255
      t.column :price, :integer, :limit => 10
      t.column :min_order, :integer, :limit => 10
      t.column :active, :string, :default => '1'
      t.column :product_id, :integer, :limit => 10
      t.column :public, :string
    end
    create_table :ship_addresses do |t|
      t.column :code, :string, :limit => 255
      t.column :name, :string, :limit => 255
      t.column :telephone, :string, :limit => 255
      t.column :address, :string, :limit => 255
      t.column :address_2, :string, :limit => 255
      t.column :city, :string, :limit => 255
      t.column :cap, :string, :limit => 255
      t.column :country, :string, :limit => 255
      t.column :note, :text
      t.column :user_id, :integer, :limit => 10
    end
    create_table :cupons_products do |t|
      t.column :cupon_id, :integer, :limit => 10
      t.column :product_id, :integer, :limit => 10
    end
    create_table :reviews do |t|
      t.column :name, :string, :limit => 255
      t.column :description, :text
      t.column :reviewer_id, :integer, :limit => 10
      t.column :reviewer_type, :string, :limit => 255
      t.column :user_id, :integer, :limit => 10
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    create_table :settings do |t|
      t.column :wine_pdf_id, :integer, :limit => 10
      t.column :order_amount, :float, :default => '0.00'
      t.column :order_cupon_amount, :float, :default => '0.00'
      t.column :order_delivery_amount, :float, :default => '0.00'
      t.column :home_image_id, :integer, :limit => 10
      t.column :home_image_url, :string, :limit => 255
    end
    create_table :images do |t|
      t.column :name, :string, :limit => 255
    end
    create_table :deliveries do |t|
      t.column :name, :string, :limit => 255
      t.column :price, :float, :default => '0.00'
    end
    create_table :schemaInfo, :id => false do |t|
      t.column :version, :integer, :limit => 10
    end
    create_table :search_queries do |t|
      t.column :query, :string, :limit => 255
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    create_table :gift_options do |t|
      t.column :name, :string, :limit => 255
      t.column :description, :text
      t.column :price, :float, :default => '0.00'
      t.column :is_default, :string, :default => '0'
    end
  end

  def self.down
    drop_table :product_correlations
    drop_table :wish_lists
    drop_table :posts
    drop_table :attribute_items
    drop_table :products
    drop_table :users
    drop_table :payment_methods
    drop_table :attribute_sets
    drop_table :recipe_correlations
    drop_table :types
    drop_table :orders
    drop_table :attributions
    drop_table :recipe_levels
    drop_table :subscriptions
    drop_table :order_items
    drop_table :blog_types
    drop_table :recipe_types
    drop_table :categories
    drop_table :recipes
    drop_table :news_letters_products
    drop_table :categorizations
    drop_table :status_news_letters
    drop_table :news_letters
    drop_table :comments
    drop_table :resources
    drop_table :slugs
    drop_table :news_letter_types
    drop_table :cupons
    drop_table :ship_addresses
    drop_table :cupons_products
    drop_table :reviews
    drop_table :settings
    drop_table :images
    drop_table :deliveries
    drop_table :schemaInfo
    drop_table :search_queries
    drop_table :gift_options
  end
end
