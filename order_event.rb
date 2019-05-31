class OrderEvent

  attr_reader :order_id, :date, :customer_id, :item_ordered, :item_quantity, :item_price
  attr_accessor :processed
  def initialize( order_id:, date:, customer_id:, item_ordered:, item_quantity:, item_price:, processed: false)
    @order_id = order_id,
    @date = date,
    @customer_id = customer_id,
    @item_ordered = item_ordered,
    @item_quantity = item_quantity,
    @item_price = item_price,
    @processed = processed
  end

end 
