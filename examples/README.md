# Examples

The `ballerina/etl` package provides practical examples illustrating its usage in various scenarios. Explore these examples, covering different use cases:

1. [Customer Data Processing](https://github.com/module-ballerina-etl/tree/main/examples/customer-data-processing/) - Processes customer data collected from various sources by extracting relevant information, cleaning and validating fields, enriching with additional metadata, and categorizing the data for downstream applications.

2. [Product Catalog Processing](https://github.com/module-ballerina-etl/tree/main/examples/product-catalog-processing/) - Consolidates product catalog data from multiple sources by extracting and merging entries, encrypting sensitive fields, classifying products into relevant categories, and storing the structured data securely in a MySQL database for easy access and analysis.

3. [User Feedback Analysis](https://github.com/module-ballerina-etl/tree/main/examples/user-feedback-analysis/) - Handles raw user feedback by extracting and standardizing input, classifying comments based on content and sentiment, and storing the processed feedback for further analysis.

## Prerequisites

1. Create an [OpenAI account](https://platform.openai.com) and obtain an [API key](https://platform.openai.com/account/api-keys).

2. Add the relevant configuration in the `Config.toml` file as follows.:

```toml
[ballerina.etl.modelConfig]
connectionConfig.auth.token = "<OPEN_AI_KEY>"
model = "<GPT_MODEL>"
```

- Replace `<OPEN_AI_KEY>` with the key you obtained, and `<GPT_MODEL>` with one of the supported GPT models listed below:
    - `"gpt-4-turbo"`
    - `"gpt-4o"`
    - `"gpt-4o-mini"`

## Running an Example

Execute the following commands to build and run an example from the source:

* To build an example:

    ```bash
    $ bal build
    ```

* To run an example:

    ```bash
    $ bal run
    ```
