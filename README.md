# Refrostly
## Setup

1.  If Ruby is not installed, please run `brew install ruby`
2.  Run git clone `https://github.com/cassyarchibald/refrostly.git`
3.  cd into `refrostly`
4.  Run `gem install bundler` if you do not have bundler installed
4.  Run `bundle install` to install ruby dependencies
5.  Run `rake test` to verify all tests are passing
6.  Run `ruby sample_data.rb` to run a sample order data/restock data 

## Class Overview
### Data Processor.rb
The Data Processor is given a json file of order event and restock events to process. 
The data processor is given an order file, a restock file, a store name, and the warehouse name. 

The data processor's output will be success/a summary of remaining inventory or
 out of stock/a summary of what items went out of stock/when the store ran out of stock.

### Order Event.rb
A Order Event represents an order from a customer for the store to fulfill.

### Restock Event.rb
A Restock Event represents the store purchasing more inventory from a manufacturer.

### Store.rb
A Store represents the store that is buying/selling inventory. 

### Warehouse.rb
A Warehouse represents a warehouse that holds the inventory for a store.

## Design Decisions
I decided to have the Data Processor class as a main driver for the algorithm. 
This way store owners could provide different combinations of order events/restock events
and analyze the results. 

The data processor loads the data from the given order and restock json files, parses the data into order events/restock events, combines the data into a sorted array of events, then requests that the store processes each event. 

After all events are processed, the status of the data processor is updated to either SUCCESS or OUT OF STOCK.
The result of the program is then shown. 
If the status of the data processor is success, the remaining inventory will be shown. If the status of the data processor is out of stock, the items that ran out of stock are displayed with the dates/times stock was not available to fulfill the order.

The store is initialized with an empty warehouse and an empty hash of unprocessed items. 
When given an event to process, the store will forward the request to its warehouse to process.
If the order is not able to be processed by the warehouse, the item and the date/time of the order are added to the unprocessed items hash. 
If requested, the store can display all unprocessed items/the dates/times the items ran out of stock. 

The warehouse tracks the overall inventory for the store. When processing a restock event, it will increase the inventory for the item. 
When processing an order, it will check if there is enough inventory to fulfill the order. If so, the inventory for the item is decreased/the order processed status is updated to true. 
The warehouse is also able to show the overall inventory.

## Assumptions Made

- I assumed that it was possible to not have stock for an item the order would not be processed. Rather than partially filling an order, the inventory remains untouched. 
If later an order that could be fulfilled given the current stock, the order would be fulfilled. 
- I assumed that the program would be given a orders event file and restock events file in json format.
- I assumed that it was possible to run out of stock multiple times. For example:
    - There are 5 shovels in inventory to start 
    - An order came in for 6 shovels, the order is not processed/the unprocessed item summary now has this item/the date and time of this order 
    - An order then came in for 3 shovels. The order is processed/inventory is reduced from 5 to 2
    - then an order for 5 shovels, the order is not processed/the unprocessed inventory for shovels now has two entries for when it ran out of stock 

## Future Plans
- Check for invalid input 
- Update so user can provide file paths for the order events/restock events files via command line
- Update so after files are processed user can enter a prompt to view the warehouse inventory
- Save the orders that could not be processed/set fulfilling those orders as a higher priority than later orders