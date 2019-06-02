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

  it "results in success if all orders were processed" do
    assert_equal "SUCCESS", @data_processor_with_enough_stock.status
    expected_remaining_inventory = {"shovel" => 0, "sled" => 9, "skis" => 0, "snowblower" => 10, "winter tires" => 2}
    assert_equal expected_remaining_inventory, @data_processor_with_enough_stock.store.warehouse.inventory
  end

  # it "results in out of stock if all orders were not processed" do
  #   assert_equal "OUT OF STOCK", @data_processor_without_enough_stock.status
  #   expected_remaining_inventory = {"shovel" => 0, "sled" => 0, "skis" => 0, "snowblower" => 5, "winter tires" => 0}
  #   assert_equal expected_remaining_inventory, @data_processor_without_enough_stock.store.warehouse.inventory
  # end


end