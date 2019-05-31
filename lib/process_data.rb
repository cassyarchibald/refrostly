require 'json'
require 'date'
require_relative 'store'
require_relative 'order_event'
require_relative 'restock_event'

class DataProcessor
  attr_reader :events, :store
  attr_accessor :status

  def initialize(order_file:, restock_file:, store_name:, warehouse_name:)
    @events = Array.new
    @status = "Not started"
    @store = Store.new(store_name, warehouse_name)
    @order_data = JSON.parse(File.read(order_file))
    @restock_data = JSON.parse(File.read(restock_file))
    parse_order_data
    parse_restock_data
    @events = @events.sort_by { |event| event.date }
    process_events
    p @store.unprocessed_items["sled"].first.to_s
    update_status
  end

  private
  def parse_order_data
    @order_data.each do |order_data|

      date = DateTime.parse(order_data["order_date"])

          order = OrderEvent.new(
          order_id: order_data["order_id"],
          date: date,
          customer_id: order_data["customer_id"],
          item_ordered: order_data["item_ordered"],
          item_quantity: order_data["item_quantity"],
          item_price: order_data["item_price"]
      )
      @events << order
    end
  end

  def parse_restock_data
    @restock_data.each do |restock_data|

      date = DateTime.parse(restock_data["restock_date"])
      restock_event =  RestockEvent.new(
          date: date,
          item_stocked: restock_data["item_stocked"],
          item_quantity: restock_data["item_quantity"],
          manufacturer: restock_data["manufacturer"],
          wholesale_price: restock_data["wholesale_price"]
      )
      @events << restock_event
    end
  end

  def process_events
    @events.each do |event|
      event.class == OrderEvent ? @store.process_order_event(event) : @store.process_restock_event(event)
      end
  end

  def update_status
    @status =  @store.unprocessed_items.length > 0 ? "OUT OF STOCK" : "SUCCESS"
  end

  def show_result
    if @status == "SUCCESS"
      @warehouse.show_inventory
    elsif @status == "OUT OF STOCK"
      @store.show_unprocessed_items
    end
  end

end

testDataRun = DataProcessor.new(
    order_file: "orders.json",
    restock_file: "restocks.json",
    store_name: "Refrostly",
    warehouse_name: "warehouse_5"
)
p testDataRun.status

# testDataRun.store.unprocessed_items.each do |item|
# #   p item
# # end
#
