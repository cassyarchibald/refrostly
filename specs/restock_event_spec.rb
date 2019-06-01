require_relative 'spec_helper'

require_relative 'spec_helper'

describe "RestockEvent" do

  before do
    @restock_event = RestockEvent.new(
        date: DateTime.parse("2018-02-01T04:00:00Z"),
        item_stocked: "sled",
        item_quantity: 10,
        manufacturer: "Knightly Shovels, Inc.",
        wholesale_price: 73.62
    )
  end

  it "can be initialized" do
    expect(@restock_event).must_be_instance_of RestockEvent
    assert_equal @restock_event.date, DateTime.parse("2018-02-01T04:00:00Z")
    assert_equal @restock_event.item_stocked, "sled"
    assert_equal @restock_event.item_quantity, 10
    assert_equal @restock_event.manufacturer, "Knightly Shovels, Inc."
    assert_equal @restock_event.wholesale_price, 73.62
  end

end