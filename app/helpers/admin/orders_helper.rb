module Admin::OrdersHelper
  def render_cupon(order)
    return "#{order.cupon_code} ( "+ number_to_currency(order.cupon_price, :unit => "&pound;") +" )" unless order.cupon_code.blank?
  end
end
