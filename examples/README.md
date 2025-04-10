# Examples

The `ballerinax/etl` package provides practical examples illustrating its usage in various scenarios. Explore these examples, covering different use cases:

1. [Customer Data Processing](https://github.com/module-ballerina-etl/tree/main/examples/customer-data-processing/) - Extract, clean, validate, enrich, and categorize customer data from multiple sources.

2. [Product Catalog Processing](https://github.com/module-ballerina-etl/tree/main/examples/product-catalog-processing/) - Extract, merge, encrypt, categorize, and store product catalog data in a MySQL database.

3. [User Feedback Analysis](https://github.com/module-ballerina-etl/tree/main/examples/user-feedback-analysis/) - Extract, standardize, categorize, and store user feedback for sentiment analysis.

## Prerequisites

1. Create an [OpenAI account](https://platform.openai.com) and obtain an [API key](https://platform.openai.com/account/api-keys).

2. For each example, create a `Config.toml` file with the necessary configuration. Here's an example:

```toml
[ballerina.etl]
openAIKey = "<OPEN_AI_KEY>"
```

3. Replace `<OPEN_AI_KEY>` with the key you obtained.

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
