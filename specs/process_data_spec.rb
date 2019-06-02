require_relative 'spec_helper'

describe "DataProcessor" do

  before do
    @data_processor = DataProcessor.new(
        order_file: "files/orders.json",
        restock_file: "files/restocks.json",
        store_name: "Refrostly",
        warehouse_name: "warehouse_5"
    )
  end

  it "can be initialized" do

  end




end