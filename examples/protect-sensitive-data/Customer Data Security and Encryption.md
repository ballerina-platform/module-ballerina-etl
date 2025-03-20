## Customer Data Security and Encryption

## Overview

This example demonstrates the usage of the `etl.security` Ballerina module to enhance customer data security by encrypting, decrypting, and masking sensitive information.

## Implementation

To run this example, ensure you have [Ballerina](https://ballerina.io/downloads/) installed on your system.

Before running the example, set up the necessary input data by placing a CSV file named `customers.csv` inside the `resources` directory. The file should contain fields `name`, `city`, `phone`, `age`, `ssn`, and `email`.

The script performs the following data security operations:

1. **Encrypt Sensitive Data**: Encrypts `ssn` and `email` fields in the customer records.
2. **Write Encrypted Data**: Saves the encrypted data to `encrypted_customers.csv`.
3. **Decrypt Data**: Reads the encrypted data and decrypts `ssn` and `email` fields.
4. **Write Decrypted Data**: Stores the decrypted data in `decrypted_customers.csv`.
5. **Mask Sensitive Data**: Masks `ssn` and `email` fields by replacing characters with `x`.
6. **Write Masked Data**: Saves the masked data to `masked_customers.csv`.

## Configurations

Before running the example, set up the following configurations in a `Config.toml` file in the root directory:

```toml
key = "<YOUR_SECRET_KEY>"
```

This secret key is used for encryption and decryption.

## Run the Example

First, clone this repository, and then run the following command to execute the script:

```sh
$ bal run
```

## Output

The processed customer data is stored in the `resources` directory with the following files:
- `encrypted_customers.csv`: Contains encrypted `ssn` and `email` fields.
- `decrypted_customers.csv`: Contains decrypted `ssn` and `email` fields.
- `masked_customers.csv`: Contains masked `ssn` and `email` fields.

```
