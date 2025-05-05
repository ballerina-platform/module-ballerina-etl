## Overview

This package provides a collection of APIs designed for data processing and manipulation, enabling seamless ETL workflows and supporting a variety of use cases.

The APIs in this package are categorized into the following ETL process stages:

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

- `extractFromText`: Extracts unstructured data from a string and maps it to a ballerina record.

## Usage

### Configurations

Following APIs in this package utilize **OpenAI services** and require an **OpenAI API key** for operation.

- `categorizeSemantic`
- `extractFromText`
- `groupApproximateDuplicates`
- `maskSensitiveData`
- `standardizeData`

> **Note**: Configuration is required only for the APIs listed above. It is not needed for the use of any other APIs in this package.

#### Setting up the OpenAI API Key

1. [Create an OpenAI account](https://platform.openai.com) and obtain an [API key](https://platform.openai.com/account/api-keys).
2. Add the obtained [API key](https://platform.openai.com/account/api-keys) and a supported [GPT model](#supported-gpt-models) in the `Config.toml` file as shown below:

```toml
[ballerina.etl.modelConfig]
openAiToken = "<OPENAI_API_KEY>"
model = "<GPT_MODEL>"
```

##### Supported GPT Models

- `"gpt-4-turbo"`
- `"gpt-4o"`
- `"gpt-4o-mini"`

#### **(Optional)** Overriding Client Timeout

The default client timeout is set to 60 seconds. This value can be adjusted by specifying the `timeout` field as shown below:

```toml
[ballerina.etl.modelConfig]
openAiToken = "<OPENAI_API_KEY>"
model = "<GPT_MODEL>"
timeout = 120.0
```

### Dependent Type Support

All APIs in this package support dependent types. Here is an example of how to use them:

```ballerina
import ballerina/etl;
import ballerina/io;

type Customer record {|
   string name;
   string city;
|};

public function main() returns error? {
   Customer[] dataset = [
      { name: "Alice", city: "New York" },
      { name: "Bob", city: "Los Angeles" },
      { name: "Alice", city: "New York" }
   ];
   Customer[] uniqueData = check etl:removeDuplicates(dataset);
   io:println(`Customer Data Without Duplicates : ${uniqueData}`);
}
```

## Examples

The `ballerina/etl` package provides practical examples illustrating its usage in various scenarios. Explore these examples, covering different use cases:

1. [Customer Data Processing](https://github.com/module-ballerina-etl/tree/main/examples/customer-data-processing/) - Processes customer data collected from various sources by extracting relevant information, cleaning and validating fields, enriching with additional metadata, and categorizing the data for downstream applications.

2. [Product Catalog Processing](https://github.com/module-ballerina-etl/tree/main/examples/product-catalog-processing/) - Consolidates product catalog data from multiple sources by extracting and merging entries, encrypting sensitive fields, classifying products into relevant categories, and storing the structured data securely in a MySQL database for easy access and analysis.

3. [User Feedback Analysis](https://github.com/module-ballerina-etl/tree/main/examples/user-feedback-analysis/) - Handles raw user feedback by extracting and standardizing input, classifying comments based on content and sentiment, and storing the processed feedback for further analysis.
