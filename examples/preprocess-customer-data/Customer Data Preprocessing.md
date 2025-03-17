## Customer Data Cleaning and Preprocessing

## Overview

This example demonstrates the usage of the `etl.cleaning` Ballerina module to automate customer data cleaning and preprocessing.

## Implementation

To run this example, ensure you have [Ballerina](https://ballerina.io/downloads/) installed on your system.

Before running the example, set up the necessary input data by placing a CSV file named `customer_data.csv` inside the `resources` directory. The file should contain fields `name`, `age`, `phone`, and `email`.

The script performs the following data cleaning and transformation steps:

1. **Read Customer Data**: Loads the raw customer data from `customer_data.csv`.
2. **Remove Age Field**: Drops the `age` field from all customer records.
3. **Trim White Spaces**: Removes leading and trailing spaces from all fields.
4. **Remove Null Values**: Eliminates records containing null values.
5. **Remove Duplicates**: Filters out duplicate customer records.
6. **Sort by Name**: Orders the records alphabetically by the `name` field.
7. **Format Phone Numbers**: Replaces leading zeros with the country code `+94`.
8. **Write Processed Data**: Saves the cleaned and formatted data to `preprocessed_customer_data.csv`.

## Run the Example

First, clone this repository, and then run the following command to execute the script:

```sh
$ bal run
```

## Output

The processed customer data is written to `preprocessed_customer_data.csv` inside the `resources` directory, ready for further analysis or integration.