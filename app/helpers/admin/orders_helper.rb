module Admin::OrdersHelper
  def render_cupon(order)
    unless order.cupon_code.blank?
      @cupon = Cupon.find_by_code(order.cupon_code)
      unless @cupon.nil?
       # return "#{order.cupon_code} ( "+ number_to_currency(order.cupon_price, :unit => "£") +" )"
       return "#{@cupon.code} ( "+ number_to_currency(@cupon.price, :unit => "£") +" )"
      else
        return ""
      end
    end
  end
end

