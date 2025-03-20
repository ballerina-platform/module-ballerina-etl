# Ballerina ETL Library

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
- `standardizeData`: Standardizes a dataset by replacing approximate matches in a string field with a specified search value.
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

type Customer record {
    string name;
    string city;
};

Customer[] dataset = [
    { "name": "Alice", "city": "New York" },
    { "name": "Bob", "city": "Los Angeles" },
    { "name": "Alice", "city": "New York" }
];

public function main() returns error? {
    Customer[] uniqueData = check etl:removeDuplicates(dataset);
}
```

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.