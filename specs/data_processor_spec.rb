require_relative 'spec_helper'

describe "DataProcessor" do

  before do
    @data_processor_with_enough_stock = DataProcessor.new(
        order_file: "test_files/test_order_events.json",
        restock_file: "test_files/test_restock_events.json",
        store_name: "Refrostly",
        warehouse_name: "warehouse_5"
    )

    @data_processor_without_enough_stock = DataProcessor.new(
        order_file: "test_files/test_order_events_for_out_of_stock.json",
        restock_file: "test_files/test_restock_events.json",
        store_name: "Refrostly",
        warehouse_name: "warehouse_5"
    )
  end

  it "can be initialized with enough stock on hand to process all orders" do
    expect(@data_processor_with_enough_stock.must_be_instance_of DataProcessor)
    expect(@data_processor_with_enough_stock.store).must_be_instance_of Store
  end

  it "can be initialized without enough stock on hand to process all orders" do
    expect(@data_processor_without_enough_stock.must_be_instance_of DataProcessor)
    expect(@data_processor_without_enough_stock.store).must_be_instance_of Store
  end




end