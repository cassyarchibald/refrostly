require_relative 'spec_helper'

describe "OrderEvent" do

  before do
    @order_event = OrderEvent.new(
        order_id: "999",
        customer_id: "1",
        date: DateTime.parse("2018-02-02T13:13:29"),
        item_ordered: "sled",
        item_quantity: 3,
        item_price: "96.33",
        )
  end

  it "can be initialized" do
    expect(@order_event).must_be_instance_of OrderEvent
    assert_equal @order_event.order_id, "999"
    assert_equal @order_event.customer_id, "1"
    assert_equal @order_event.date, DateTime.parse("2018-02-02T13:13:29")
    assert_equal @order_event.item_ordered, "sled"
    assert_equal @order_event.item_quantity, 3
    assert_equal @order_event.item_price, "96.33"
    assert_equal @order_event.processed, false
  end

end