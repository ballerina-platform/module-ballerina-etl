## Overview

This package provides a collection of functions designed for data processing and manipulation, enabling seamless ETL workflows and supporting a variety of use cases.

The functions in this package are categorized into the following ETL process stages:
- Data Categorization
- Data Cleaning
- Data Enrichment
- Data Filtering
- Data Security
- Unstructured Data Extraction

## Features

### Data Categorization
- `categorizeNumeric`: Categorizes a dataset based on a numeric field and specified ranges.
- `categorizeRegexData`: Categorizes a dataset based on a string field using a set of regular expressions.
- `categorizeSemantic`: Categorizes a dataset based on a string field using semantic classification.

### Data Cleaning
- `groupApproximateDuplicates`: Identifies and groups approximate duplicates in a dataset, returning a nested array with unique records first, followed by groups of similar records.
- `handleWhiteSpaces`: Returns a new dataset with all extra whitespace removed from string fields.
- `removeDuplicates`: Returns a new dataset with all duplicate records removed.
- `removeEmptyValues`: Returns a new dataset with all records containing nil or empty string values removed.
- `removeField`: Returns a new dataset with a specified field removed from each record.
- `replaceText`: Returns a new dataset where matches of the given regex pattern in a specified string field are replaced with a new value.
- `sortData`: Returns a new dataset sorted by a specified field in ascending or descending order.
- `standardizeData`: Returns a new dataset with all string values in a specified field standardized to a set of standard values.

### Data Enrichment
- `joinData`: Merges two datasets based on a common specified field and returns a new dataset with the merged records.
- `mergeData`: Merges multiple datasets into a single dataset by flattening a nested array of records.

### Data Filtering
- `filterDataByRatio`: Filters a random set of records from a dataset based on a specified ratio.
- `filterDataByRegex`: Filters a dataset based on a regex pattern match.
- `filterDataByRelativeExp`: Filters a dataset based on a relative numeric comparison expression.

### Data Security
- `decryptData`: Returns a new dataset with specified fields encrypted using AES-ECB encryption with a given symmetric key.
- `encryptData`: Returns a new dataset with specified fields encrypted using AES-ECB encryption with a given symmetric key.
- `maskSensitiveData`: Returns a new dataset with PII (Personally Identifiable Information) fields masked using a specified character

### Unstructured Data Extraction
- `extractFromUnstructuredData`: Extracts unstructured data from a string and maps it to a ballerina record.

## Usage

### Configurations

The following APIs require an OpenAI API key to operate:
- `categorizeSemantic`
- `extractFromUnstructuredData`
- `groupApproximateDuplicates`
- `maskSensitiveData`
- `standardizeData`

If your Ballerina application uses any of these functions, follow the steps below before calling them:

1. Create an [OpenAI account](https://platform.openai.com) and obtain an [API key](https://platform.openai.com/account/api-keys).

2. Values need to be provided for the `modelConfig` configurable value. Add the relevant configuration in the `Config.toml` file as follows.

```toml
[ballerina.etl.modelConfig]
openAIToken = "<OPEN_AI_KEY>"
model = "<GPT_MODEL>"
```

- Replace `<OPEN_AI_KEY>` with the key you obtained, and `<GPT_MODEL>` with one of the supported GPT models listed below:
    - `"gpt-4-turbo"`
    - `"gpt-4o"`
    - `"gpt-4o-mini"`

4. **(Optional)** If you want to increase the client timeout (the default is 60 seconds), set the `connectionConfig.auth.timeout` field as shown below:

```toml
timeout = <TIMEOUT_IN_SECONDS>
```

- Replace `<TIMEOUT_IN_SECONDS>` with your desired timeout duration. 

### Dependent Type Support 

All functions in this package support dependent types. Here is an example of how to use them:

```ballerina 
import ballerina/etl;
import ballerina/io;

type Customer record {|
    string name;
    string city;
|};

Customer[] dataset = [
    { name: "Alice", city: "New York" },
    { name: "Bob", city: "Los Angeles" },
    { name: "Alice", city: "New York" }
];

public function main() returns error? {
    Customer[] uniqueData = check etl:removeDuplicates(dataset);
    io:println(`Customer Data Without Duplicates : ${uniqueData}`);
}
```

## Examples

The `ballerina/etl` package provides practical examples illustrating its usage in various scenarios. Explore these examples, covering different use cases:

1. [Customer Data Processing](https://github.com/module-ballerina-etl/tree/main/examples/customer-data-processing/) - Processes customer data collected from various sources by extracting relevant information, cleaning and validating fields, enriching with additional metadata, and categorizing the data for downstream applications.

2. [Product Catalog Processing](https://github.com/module-ballerina-etl/tree/main/examples/product-catalog-processing/) - Consolidates product catalog data from multiple sources by extracting and merging entries, encrypting sensitive fields, classifying products into relevant categories, and storing the structured data securely in a MySQL database for easy access and analysis.

3. [User Feedback Analysis](https://github.com/module-ballerina-etl/tree/main/examples/user-feedback-analysis/) - Handles raw user feedback by extracting and standardizing input, classifying comments based on content and sentiment, and storing the processed feedback for further analysis.
