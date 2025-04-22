# User Feedback Analysis

## Overview

This example demonstrates the use of the `ballerina/etl` module in Ballerina to process user feedback data. It extracts, transforms, categorizes, and loads feedbacks into CSV files for further analysis.

## Implementation

To run this example, ensure you have [Ballerina](https://ballerina.io/downloads/) installed on your system.

The script follows these steps:

1. **Extract Data**:
   - Loads customer feedback data from a text file (`feedbacks.txt`).

2. **Standardize Data**:
   - Standardizes brand names to match a predefined list of product names: `NeoBook Pro`, `XenPhone X`, `FlexFit Pro`, `EchoBuds 3`, and `FusionBlend 500`.

3. **Categorize Data**:
   - Classifies the feedback into two categories based on sentiment:
     - **Positive**: Positive feedback about the product.
     - **Negative**: Negative feedback about the product.

4. **Load Data into CSV**:
   - Saves the categorized feedback into two separate CSV files:
     - `positive_feedbacks.csv`
     - `negative_feedbacks.csv`

## Configurations

## Configurations

Before running the example, ensure that your `Config.toml` file is set up in the root directory as follows:

```toml
[ballerina.etl.modelConfig]
openAIToken = "<OPEN_AI_KEY>"
model = "<GPT_MODEL>"
```

## Run the Example

Clone this repository, and then execute the following command to run the script:

```sh
$ bal run
```

## Output

Upon successful execution, the processed and categorized feedbacks will be stored in the following CSV files:

- `positive_feedbacks.csv`: Contains positive feedback.
- `negative_feedbacks.csv`: Contains negative feedback.
