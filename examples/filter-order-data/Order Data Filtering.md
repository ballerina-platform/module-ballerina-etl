## Order Data Filtering

## Overview

This example demonstrates the usage of the `etl.filtering` Ballerina module to filter order data based on price, categorizing them into expensive and cheap orders.

## Implementation

To run this example, ensure you have [Ballerina](https://ballerina.io/downloads/) installed on your system.

Before running the example, set up the necessary input data by placing a CSV file named `order_data.csv` inside the `resources` directory. The file should contain fields `id`, `customer`, and `price`.

The script performs the following data filtering operations:

1. **Read Order Data**: Loads raw order data from `order_data.csv`.
2. **Filter Orders**: Categorizes orders into two groups based on price:
   - Expensive orders (price greater than 100).
   - Cheap orders (price less than or equal to 100).
3. **Write Filtered Data**: Saves the categorized data to separate CSV files.

## Run the Example

First clone this repository, and then run the following command to execute the script:

```sh
$ bal run
```

## Output

The processed order data is stored in the `resources` directory with the following files:
- `expensive_orders.csv`: Contains orders with a price greater than 100.
- `cheap_orders.csv`: Contains orders with a price less than or equal to 100.