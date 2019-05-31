class RestockEvent

  attr_reader :date, :item_stocked, :item_quantity, :manufacturer, :wholesale_price

  def initialize(date:, item_stocked:, item_quantity:, manufacturer:, wholesale_price:)
    @date = date
    @item_stocked= item_stocked
    @item_quantity = item_quantity
    @manufacturer = manufacturer
    @wholesale_price = wholesale_price
  end

end
