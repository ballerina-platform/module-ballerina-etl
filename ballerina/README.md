## Overview

This package provides a collection of functions designed for data processing and manipulation, enabling seamless ETL workflows and supporting a variety of use cases.

The functions in this package are categorized into the following ETL process stages:
- Unstructured Data Extraction
- Data Cleaning
- Data Enrichment
- Data Security
- Data Filtering
- Data Categorization

## Features

### Unstructured Data Extraction
- `extractFromUnstructuredData`: Extracts relevant details from a string array and maps them to the specified fields using OpenAI's GPT model.

### Data Cleaning
- `standardizeData`: Standardizes string values in a dataset based on approximate matches.
- `groupApproximateDuplicates`: Identifies approximate duplicates in a dataset and groups them, returning unique records separately.
- `removeNull`: Removes records that contain null or empty string values in any field.
- `removeDuplicates`: Removes exact duplicate records from a dataset based on their content.
- `removeField`: Removes a specified field from each record in the dataset.
- `replaceText`: Replaces text in a specific field of a dataset using regular expressions.
- `sortData`: Sorts a dataset based on a specific field in ascending or descending order.
- `handleWhiteSpaces`: Cleans up whitespace in all fields of a dataset by replacing multiple spaces with a single space and trimming the values.

### Data Enrichment
- `joinData`: Merges two datasets based on a common primary key, updating records from the first dataset with matching records from the second.
- `mergeData`: Merges multiple datasets into a single dataset by flattening a nested array of records.

### Data Security
- `encryptData`: Encrypts a dataset using AES-ECB encryption with a given Base64-encoded key.
- `decryptData`: Decrypts a dataset using AES-ECB decryption with a given Base64-encoded key, returning records of the specified type.
- `maskSensitiveData`: Masks specified fields of a dataset by replacing each character in the sensitive fields with a masking character.

### Data Filtering
- `filterDataByRatio`: Splits a dataset into two parts based on a given ratio.
- `filterDataByRegex`: Filters a dataset into two subsets based on a regex pattern match.
- `filterDataByRelativeExp`: Filters a dataset based on a relative numeric comparison expression.

### Data Categorization
- `categorizeNumeric`: Categorizes a dataset based on a numeric field and specified ranges.
- `categorizeRegexData`: Categorizes a dataset based on a string field using a set of regular expressions.
- `categorizeSemantic`: Categorizes a dataset based on a string field using semantic classification via OpenAI's GPT model.

## Usage

### Configurations

The following functions require an OpenAI API key to operate:
- `extractFromUnstructuredData`
- `groupApproximateDuplicates`
- `standardizeData`
- `maskSensitiveData`
- `categorizeSemantic`

If your Ballerina application uses any of these functions, follow the steps below before calling them:

1. Create an [OpenAI account](https://platform.openai.com) and obtain an [API key](https://platform.openai.com/account/api-keys).

2. Ensure that your `Config.toml file in the root directory is configured as follows:

```toml
[ballerina.etl]
openAIKey = "<OPEN_AI_KEY>"
```

3. Replace `<OPEN_AI_KEY>` with the key you obtained.

### Dependent Type Support 

All functions in this package support dependent types. Here is an example of how to use them:

```ballerina 
import ballerina/etl;

type Customer record {|
    string name;
    string city;
|};

Customer[] dataset = [
    { "name": "Alice", "city": "New York" },
    { "name": "Bob", "city": "Los Angeles" },
    { "name": "Alice", "city": "New York" }
];

public function main() returns error? {
    Customer[] uniqueData = check etl:removeDuplicates(dataset);
}
```
