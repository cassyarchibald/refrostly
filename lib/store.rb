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
    @warehouse.process_order(order)
    # If not processed, add to hash of when that product ran out of stock
    if order.processed == false
      if @unprocessed_items[order.item_ordered]
        @unprocessed_items[order.item_ordered] << order.date
      else
        @unprocessed_items[order.item_ordered] = Array.new
        @unprocessed_items[order.item_ordered] <<= order.date
      end
    end
  end

  # TODO - figure out what to do with below method
  def show_unprocessed_items
    @unprocessed_items.each do |item|

    end
  end

private


end

