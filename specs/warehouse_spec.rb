require_relative 'spec_helper'

describe "Warehouse" do

  before do
    @warehouse = Warehouse.new("Warehouse")
    @order_event = OrderEvent.new(
        order_id: "999",
        customer_id: "1",
        date: DateTime.parse("2018-02-02T13:13:29"),
        item_ordered: "sled",
        item_quantity: 3,
        item_price: "96.33",
        )
    @restock_event = RestockEvent.new(
        date: DateTime.parse("2018-02-01T04:00:00Z"),
        item_stocked: "sled",
        item_quantity: 10,
        manufacturer: "Knightly Shovels, Inc.",
        wholesale_price: 73.62
    )
  end

  it "can be initialized" do
    expect(@warehouse).must_be_instance_of Warehouse
    assert_equal @warehouse.name, "Warehouse"
    assert_equal @warehouse.inventory, {"skis"=>0, "shovel"=>0, "sled"=>0, "snowblower"=>0, "tires"=>0}
  end

  it "can process a restock event" do
    @warehouse.process_restock_event(@restock_event)
    assert_equal 10, @warehouse.inventory["sled"]
  end

  it "can process a order event with inventory" do
    @warehouse.process_restock_event(@restock_event)
    @warehouse.process_order_event(@order_event)
    assert_equal 7, @warehouse.inventory["sled"]
    assert_equal true, @order_event.processed
  end

  it "does not process an order if the quantity is more than what the store has in stock" do
    @warehouse.process_restock_event(@restock_event)
    order = OrderEvent.new(
        order_id: "999",
        customer_id: "1",
        date: DateTime.parse("2018-02-02T13:13:29"),
        item_ordered: "sled",
        item_quantity: 99,
        item_price: "96.33",
        )
    @warehouse.process_order_event(order)
    assert_equal 10, @warehouse.inventory["sled"]
    assert_equal 99, order.item_quantity
    assert_equal false, order.processed
  end

end