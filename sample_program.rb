require_relative "lib/data_processor"


testDataRun = DataProcessor.new(
    order_file: "files/orders.json",
    restock_file: "files/restocks.json",
    store_name: "Refrostly",
    warehouse_name: "warehouse_5"
)
p testDataRun.status
p testDataRun.store.warehouse.name