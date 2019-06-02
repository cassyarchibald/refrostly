require 'json'
require 'date'
require_relative 'store'
require_relative 'order_event'
require_relative 'restock_event'

class DataProcessor
  attr_reader :store, :status

  def initialize(order_file:, restock_file:, store_name:, warehouse_name:)
    @events = Array.new
    @status = "Not started"
    @store = Store.new(store_name, warehouse_name)
    load_data(order_file, restock_file)
    @events = @events.sort_by { |event| event.date }
    process_events
    update_status
    print show_result
  end

  private
  def load_data(order_file, restock_file)
    # If I had additional time, I would wrap this to check if load/parse was successful
    @order_data = JSON.parse(File.read(order_file))
    @restock_data = JSON.parse(File.read(restock_file))
    parse_order_data
    parse_restock_data
  end

  def parse_order_data
    @order_data.each do |order_data|

      date = DateTime.parse(order_data["order_date"])

          order = OrderEvent.new(
          order_id: order_data["order_id"],
          date: date,
          customer_id: order_data["customer_id"],
          item_ordered: order_data["item_ordered"].downcase,
          item_quantity: order_data["item_quantity"].to_i,
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
          item_stocked: restock_data["item_stocked"].downcase,
          item_quantity: restock_data["item_quantity"].to_i,
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
    result = "*********** #{@status} ***********"
    if @status == "SUCCESS"
      result += "\n\tAll orders were processed. \n\tBelow is the remaining inventory:"
      result += @store.warehouse.show_inventory
    elsif @status == "OUT OF STOCK"
      result += "\nNot all orders were processed due to running out of inventory"
      result += "\nBelow are the items that ran out of stock/when the items ran out:"
      result += @store.show_unprocessed_items
    end
    return result
  end

end