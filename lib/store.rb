require_relative 'warehouse'

class Store

  attr_reader :name, :warehouse
  attr_accessor :unprocessed_items

  def initialize(store_name, warehouse_name)
    @name = store_name
    @warehouse = Warehouse.new(warehouse_name)
    @unprocessed_items = Hash.new()
  end

  def process_restock_event(restock_event)
    @warehouse.process_restock_event(restock_event)
  end

  def process_order_event(order)
    @warehouse.process_order_event(order)
    # If not processed, add to hash of when that product ran out of stock
    if order.processed == false
      if @unprocessed_items[order.item_ordered]
        @unprocessed_items[order.item_ordered] << order.date.to_s
      else
        @unprocessed_items[order.item_ordered] = Array.new
        @unprocessed_items[order.item_ordered] <<= order.date.to_s
      end
    end
  end

  # For each item, show item and a list of when it ran out of stock/could not fulfill an order
  def show_unprocessed_items
    unprocessed_items_result = "Out Of Stock Dates\n"
    @unprocessed_items.each do |item, dates|
      unprocessed_items_result += "#{item.capitalize}:\n"
      dates.each do |date|
        unprocessed_items_result += "\t\t#{(date.to_s)}\n"
      end
    end
    return unprocessed_items_result
  end
end

