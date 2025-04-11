# Product Catalog Processing

## Overview

This example demonstrates the use of the `ballerina/etl` module in Ballerina to automate product catalog data processing. It extracts, transforms, encrypts, categorizes, and loads product data into a MySQL database.

## Implementation

To run this example, ensure you have [Ballerina](https://ballerina.io/downloads/) installed on your system.

The script follows these steps:

1. **Extract Data**:
   - Loads product data from an EDI file (`product_catalog.edi`).
   - Loads additional product data from a CSV file (`new_products.csv`).
2. **Clean Data**:
   - Removes the `code` field from the extracted products.
3. **Merge Data**:
   - Combines the extracted product data with additional products.
4. **Encrypt Data**:
   - Encrypts the `supplier` field using a symmetric key.
5. **Categorize Data**:
   - Classifies products into three categories based on stock levels:
     - **Low Stock:** 0-100 units
     - **Medium Stock:** 101-300 units
     - **High Stock:** 301+ units
6. **Load Data into MySQL**:
   - Creates three tables (`low_stock_products`, `medium_stock_products`, `high_stock_products`).
   - Inserts categorized products into the corresponding tables.

## Configurations

Before running the example, ensure that your `Config.toml` file is set up in the root directory as follows:

```toml
symmetricKey = "your-encryption-key"
user = "your-mysql-username"
password = "your-mysql-password"
host = "your-mysql-host"
port = 3306
database = "your-database-name"
```

## Run the Example

Clone this repository, and then execute the following command to run the script:

```sh
$ bal run
```

## Output

Upon successful execution, the processed data will be stored in the MySQL database under the respective tables:

- `low_stock_products`
- `medium_stock_products`
- `high_stock_products`
