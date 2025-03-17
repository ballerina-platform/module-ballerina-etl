## Customer Data Enrichment

## Overview

This example demonstrates the usage of the `etl.enrichment` Ballerina module to enrich customer data by merging and joining multiple datasets.

## Implementation

To run this example, ensure you have [Ballerina](https://ballerina.io/downloads/) installed on your system.

Before running the example, set up the necessary input data by placing the following CSV files inside the `resources` directory:

- `customer_details1.csv`: Contains customer ID, name, and age.
- `customer_details2.csv`: Contains additional customer records.
- `contact_details.csv`: Contains customer ID, city, phone, and email.

The script performs the following data enrichment operations:

1. **Read Customer Details**: Loads customer details from `customer_details1.csv` and `customer_details2.csv`.
2. **Merge Customer Records**: Combines customer details from both files.
3. **Read Contact Details**: Loads contact information from `contact_details.csv`.
4. **Join Customer and Contact Data**: Merges customer records with contact details using the `customerId` field.
5. **Write Enriched Data**: Saves the enriched customer data to `customer_data.csv`.

## Run the Example

First clone this repository, and then run the following command to execute the script:

```sh
$ bal run
```

## Output

The enriched customer data is stored in the `resources` directory in the following file:
- `customer_data.csv`: Contains merged customer details along with contact information.