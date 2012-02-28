class CartItem
  attr_reader :product

  def initialize(product, qt = 1)
    @product = product
    @quantity = qt.to_i
  end

  def total
    total = price * quantity
    return total
  end

  def quantity
    return @quantity.to_i
  end

  def price
    # I dont kwnow why is necessay it because in production lost the form_quantity and form_quantity_price
    @product = Product.find(@product.id)
    if @product && @product.from_quantity > 0 && @product.from_quantity_price > 0 && quantity >= @product.from_quantity
      return ((@product.price_discounted * @product.from_quantity - @product.from_quantity_price) / @product.from_quantity).to_f
    else
      return @product.price_discounted
    end
  end


  def vat

    #	if @product && @product.from_quantity > 0 && @product.from_quantity_price > 0 && quantity >= @product.from_quantity && @product.rate == "17.5%"
    #  return ((@product.price_discounted * @product.from_quantity - @product.from_quantity_price) / @product.from_quantity / 1.175).to_f
  #	elsif @product && @product.from_quantity > 0 && @product.from_quantity_price > 0 && quantity >= @product.from_quantity
  	#  return ((@product.price_discounted * @product.from_quantity - @product.from_quantity_price) /  @product.from_quantity).to_f
  #else
  #	  return @product.vat
  #	end




	  if @product && @product.from_quantity > 0 && @product.from_quantity_price > 0 && quantity >= @product.from_quantity && @product.rate == "0%"
  	  return ((@product.price_discounted * @product.from_quantity - @product.from_quantity_price) /  @product.from_quantity).to_f
    elsif @product && @product.from_quantity > 0 && @product.from_quantity_price > 0 && quantity >= @product.from_quantity
        return ((@product.price_discounted * @product.from_quantity - @product.from_quantity_price) / @product.from_quantity / ( 1+ (@product.rate.to_f/100) )).to_f
    else
        return @product.vat
    end




  end






  def quantity=(qt)
    @quantity = qt.to_i if qt.to_i > 0
  end

  def increment_quantity
    @quantity += 1
  end
end

