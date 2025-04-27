# Customer Data Processing

## Overview

This example demonstrates the usage of the `ballerina/etl` module in Ballerina to automate customer data processing.

## Implementation

To run this example, ensure you have [Ballerina](https://ballerina.io/downloads/) installed on your system.

Before running the example, set up the necessary input data:

- Place a CSV file named `customer_details.csv` inside the `resources` directory. This file should contain fields such as `id`, `name`, `age`, `city`, `contactNumber`, and `email`.
- Place another CSV file named `customer_preferences.csv` inside the `resources` directory. This file should contain fields such as `id`, `preferredCategory`, `membershipTier`, `annualSpending`, `preferredContactMethod`, `maritalStatus`, and `occupation`.

The script performs the following data cleaning operations:

1. **Extract Customer Data**: Loads raw customer details from `customer_details.csv`.
2. **Clean Customer Data**:
   - Removes the `age` field from all customer records.
   - Trims leading and trailing spaces from all fields.
   - Eliminates records containing null values.
   - Filters out duplicate customer records.
   - Formats phone numbers by replacing leading zeros with the country code `+94`.
   - Sorts the records by `id`.
3. **Validate Customer Data**: Filters out invalid email addresses using a regular expression.
4. **Extract Customer Preferences**: Reads customer preferences from `customer_preferences.csv`.
5. **Enrich Customer Data**: Joins customer details with preferences based on the `id` field.
6. **Mask Sensitive Data**: Masks sensitive customer data before further processing.
7. **Categorize Customers**: Categorizes customers based on their `membershipTier` (Gold, Silver, Bronze).
8. **Load Categorized Data**: Saves categorized customer data into separate CSV files:
   - `gold_customers.csv`
   - `silver_customers.csv`
   - `bronze_customers.csv`

## Configurations

Before running the example, ensure that your `Config.toml` file is set up in the root directory as follows:

```toml
[ballerina.etl.modelConfig]
openAiToken = "<OPEN_AI_KEY>"
model = "<GPT_MODEL>"
```

## Run the Example

Clone this repository, and then execute the following command to run the script:

```sh
$ bal run
```

## Output

The categorized customer data is written to separate CSV files inside the `resources/categories/` directory, ready for further analysis or integration.
