class ChangeInDatatypesAndColumnName < ActiveRecord::Migration
  def self.up
    rename_column :about_us, :type, :link_type
    change_column :categories, :show_in_menu,:boolean,:defualt=>true
    change_column :categories, :show_in_boxes,:boolean,:defualt=>true
    change_column :cupons,:active,:boolean,:defualt=>true
    change_column :cupons,:public,:boolean
    change_column :deliveries,:price,:decimal,:precision=>8,:scale=>2,:default=>0.00
    change_column :gift_options,:price,:decimal,:precision=>8,:scale=>2,:default=>0.00
   change_column :gift_options,:is_default,:boolean,:default=>0
   change_column :news_letters,:customers,:boolean,:default=>1
    change_column :news_letters,:subscribers,:boolean,:default=>1
    change_column :orders,:cupon_price,:decimal,:precision=>8,:scale=>2,:default=>0.00
    change_column :orders,:paid,:boolean,:default=>0
    change_column :orders,:delivery_price,:decimal,:precision=>8,:scale=>2,:default=>0.00
    change_column :orders,:ship_a_gift,:boolean,:default=>0
    change_column :orders,:different_shipping_address,:boolean,:default=>0
    change_column :order_items,:price,:decimal,:precision=>8,:scale=>2,:default=>0.00
   change_column :order_items,:vat,:decimal,:precision=>8,:scale=>2,:default=>0.00
    change_column :payment_methods,:external,:boolean,:default=>0
    change_column :products,:price,:decimal,:precision=>8,:scale=>2,:default=>0.00
    change_column :products,:cost,:decimal,:precision=>8,:scale=>2,:default=>0.00
  change_column :products,:active,:boolean,:default=>1
  change_column :products,:raccomanded,:boolean,:default=>0
  change_column :products,:vegetarian,:boolean,:default=>0
  change_column :products,:organic,:boolean,:default=>0
  change_column :products,:upselling,:boolean
  change_column :products,:comments,:boolean
  change_column :products,:say_to_friend,:boolean
  change_column :products,:review,:boolean
  change_column :products,:from_quantity_price,:decimal,:precision=>8,:scale=>2,:default=>0.00
  change_column :products,:discount,:decimal,:precision=>8,:scale=>2,:default=>0.00
  change_column :recipes,:raccomanded,:boolean,:default=>0
  change_column :recipes,:active,:boolean,:default=>0
  change_column :settings,:order_amount,:decimal,:precision=>8,:scale=>2,:default=>0.00
  change_column :settings,:order_cupon_amount,:decimal,:precision=>8,:scale=>2,:default=>0.00
   change_column :settings,:order_delivery_amount,:decimal,:precision=>8,:scale=>2,:default=>0.00
   change_column :users,:active,:boolean,:default=>0
   change_column :users,:activation_sent,:boolean,:default=>0
   change_column :users,:news_letters,:boolean,:default=>1
   change_column :users,:ship_a_gift,:boolean,:default=>0
  end

  def self.down
    rename_column :about_us, :link_type, :type
    change_column :categories, :show_in_menu, :string
    change_column :categories, :show_in_boxes,:string
    change_column :cupons, :active,:string
    change_column :cupons,:public,:string
    change_column :deliveries,:price,:float
    change_column :gift_options,:price,:float
    change_column :gift_options,:is_default,:string
    change_column :news_letters,:customers,:string
    change_column :news_letters,:subscribers,:string
    change_column :orders,:cupon_price,:float
    change_column :orders,:paid,:string
    change_column :orders,:delivery_price,:float
    change_column :orders,:ship_a_gift,:string
    change_column :orders,:different_shipping_address,:string
    change_column :order_items,:price,:float,:default=>0
    change_column :order_items,:vat,:float,:default=>0
    change_column :payment_methods,:external,:string
    change_column :products,:price,:float,:default=>0
    change_column :products,:cost,:float,:default=>0
    change_column :products,:active,:string
    change_column :products,:raccomanded,:string
    change_column :products,:vegetarian,:string
    change_column :products,:organic,:string
    change_column :products,:upselling,:string
    change_column :products,:comments,:string
    change_column :products,:say_to_friend,:string
    change_column :products,:review,:string
    change_column :products,:from_quantity_price,:float,:default=>0
    change_column :products,:discount,:float
    change_column :recipes,:raccomanded,:string
    change_column :recipes,:active,:string
    change_column :settings,:order_amount,:float,:default=>0
    change_column :settings,:order_cupon_amount,:float,:default=>0
   change_column :settings,:order_delivery_amount,:float,:default=>0
   change_column :users,:active,:string
   change_column :users,:activation_sent,:string
   change_column :users,:news_letters,:boolean,:string
   change_column :users,:ship_a_gift,:string
  end
end

