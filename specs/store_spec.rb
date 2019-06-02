require_relative 'spec_helper'

describe 'Store' do

  before do
    @store = Store.new("test_store", "warehouse")
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
    expect(@store).must_be_instance_of Store
    assert_equal @store.name, "test_store"
    expect(@store.warehouse).must_be_instance_of Warehouse, @warehouse
    assert_equal @store.unprocessed_items.length, 0
  end

  it "can process a restock event" do
    @store.process_restock_event(@restock_event)
    assert_equal 10, @store.warehouse.inventory["sled"]
  end

  it "can process a order event with inventory" do
    @store.process_restock_event(@restock_event)
    @store.process_order_event(@order_event)
    assert_equal 7, @store.warehouse.inventory["sled"]
  end

  it "does not process an order if the quantity is more than what the store has in stock" do
    @store.process_restock_event(@restock_event)
    order = OrderEvent.new(
        order_id: "999",
        customer_id: "1",
        date: DateTime.parse("2018-02-02T13:13:29"),
        item_ordered: "sled",
        item_quantity: 99,
        item_price: "96.33",
        )
    @store.process_order_event(order)
    assert_equal 10, @store.warehouse.inventory["sled"]
    assert_equal 99, order.item_quantity
    assert_equal false, order.processed
    expect(@store.unprocessed_items["sled"]).must_equal Array.new(1, order.date.to_s)
  end

  it "can show unprocessed items" do
    @store.process_restock_event(@restock_event)
    order = OrderEvent.new(
        order_id: "999",
        customer_id: "1",
        date: DateTime.parse("2018-02-02T13:13:29"),
        item_ordered: "sled",
        item_quantity: 99,
        item_price: "96.33",
        )
    order_two = OrderEvent.new(
        order_id: "999",
        customer_id: "1",
        date: DateTime.parse("2018-02-02T13:13:29"),
        item_ordered: "shovel",
        item_quantity: 99,
        item_price: "96.33",
        )
    @store.process_order_event(order)
    @store.process_order_event(order_two)
    expected_unprocessed_items_string = "Out Of Stock Dates\n"
    expected_unprocessed_items_string += "Sled:\n\t\t2018-02-02T13:13:29+00:00\n"
    expected_unprocessed_items_string += "Shovel:\n\t\t2018-02-02T13:13:29+00:00\n"
    assert_equal expected_unprocessed_items_string, @store.show_unprocessed_items
  end

end