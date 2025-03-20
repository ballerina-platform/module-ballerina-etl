import ballerina/io;

import ballerina/etl;

configurable string key = ?;

type Customer record {
    string customerId;
    string name;
    string city;
    string phone;
    int age;
    string ssn;
    string email;
};

public function main() returns error? {
    // Encrypt the data
    Customer[] customers = check io:fileReadCsv("./resources/customers.csv");
    Customer[] encryptedCustomers = check etl:encryptData(customers, ["ssn", "email"], key);
    check io:fileWriteCsv("./resources/encrypted_customers.csv", encryptedCustomers);

    // Decrypt the data
    Customer[] encryptedData = check io:fileReadCsv("./resources/encrypted_customers.csv");
    Customer[] decryptedData = check etl:decryptData(encryptedData, ["ssn", "email"], key);
    check io:fileWriteCsv("./resources/decrypted_customers.csv", decryptedData);

    // Mask sensitive data
    Customer[] maskedCustomers = check etl:maskSensitiveData(customers, "x");
    check io:fileWriteCsv("./resources/masked_customers.csv", maskedCustomers);

}
