# Examples

The `ballerinax/etl` package provides practical examples illustrating its usage in various scenarios. Explore these examples, covering different use cases:

1. [Customer Data Processing](https://github.com/module-ballerina-etl/tree/main/examples/customer-data-processing/) - Extract, clean, validate, enrich, and categorize customer data from multiple sources.

2. [Product Catalog Processing](https://github.com/module-ballerina-etl/tree/main/examples/product-catalog-processing/) - Extract, merge, encrypt, categorize, and store product catalog data in a MySQL database.

3. [User Feedback Analysis](https://github.com/module-ballerina-etl/tree/main/examples/user-feedback-analysis/) - Extract, standardize, categorize, and store user feedback for sentiment analysis.

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
