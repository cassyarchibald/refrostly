require_relative "lib/data_processor"

puts "Welcome to Refrostly's Restocking Algorithm"
puts "This will run the provided sample order event and sample restock events"
puts "If an order is attempted and there is not enough stock available, \nthe order will not be processed and the algorithm will notify the user which products ran out of stock/when the products ran out of stock"
puts "If all provided orders were successfully stocked, \nthe algorithm will provide a summary of the remaining inventory.\n"
puts "\n*********** Processing Events With Enough Stock ***********\n"
DataProcessor.new(
    order_file: "files/order_events.json",
    restock_file: "files/restock_events.json",
    store_name: "Refrostly",
    warehouse_name: "warehouse_5"
)

puts "\n*********** Processing Events Without Enough Stock ***********\n"
DataProcessor.new(
    order_file: "files/order_events_for_out_of_stock.json",
    restock_file: "files/restock_events.json",
    store_name: "Refrostly",
    warehouse_name: "warehouse_5"
)

