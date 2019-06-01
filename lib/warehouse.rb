class Warehouse

  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new
    initialize_stock
  end


  def process_order(order)
    # If inventory cannot fulfill order, do not process order
    if @inventory[order.item_ordered] >= order.item_quantity
      @inventory[order.item_ordered] -= order.item_quantity
      order.processed = true
    end
  end

  def process_restock_event(restock)
    if @inventory[restock.item_stocked]
      @inventory[restock.item_stocked] += restock.item_quantity
    else
      raise ArgumentError, "Invalid product #{restock.item_stocked} provided"
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