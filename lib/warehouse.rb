class Warehouse

  attr_reader :name, :inventory

  def initialize(name:)
    @name = name,
    @inventory = Hash.new
    initialize_stock
  end


  def process_order(order)
    if @inventory[order.item_ordered] != 0
      @inventory[order.item_ordered] -= 1
      order.processed = true
    end
  end

  def process_restock_event(event)
    if @inventory[event.item_stocked]
      @inventory[event.item_stocked] += 1
    else
      raise ArgumentError, "Invalid product #{event.item_stocked} provided"
    end
  end

  def show_inventory
    @inventory.each do |item|
      puts "#{item.item_quantity} #{item.item_stocked}"
    end
  end

  private
  def initialize_stock
    products = ["skis", "shovel", "sled", "snowblower", "tires"]
    products.each do |product|
      @inventory[product] = 0
    end
  end


end