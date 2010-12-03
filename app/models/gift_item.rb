class GiftItem
  attr_reader :gift_option_id
  attr_reader :note
  
  def initialize(gift_option_id=nil, note=nil)
    @gift_option_id = gift_option_id ||= GiftOption.get_default
    @note = note
  end
  
  def price
    gift_option = GiftOption.find_by_id(@gift_option_id)
    return gift_option.price if gift_option
    return 0
  end
end