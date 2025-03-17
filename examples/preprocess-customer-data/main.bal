import ballerina/etl;
import ballerina/io;

type Customer record {
    string? name;
    int? age?;
    string? phone;
    string? email?;
};

public function main() returns error? {
    // Read customer data from the CSV file
    Customer[] rawCustomerData = check io:fileReadCsv("./resources/customer_data.csv");

    // Remove age field from the customer data
    Customer[] cleanedCustomers = check etl:removeField(rawCustomerData, "email");

    // Trim white spaces in all fields
    Customer[] trimmedCustomerData = check etl:handleWhiteSpaces(cleanedCustomers);

    // Remove records with null values
    Customer[] nonNullCustomerData = check etl:removeNull(trimmedCustomerData);

    // Remove duplicate records
    Customer[] uniqueCustomerData = check etl:removeDuplicates(nonNullCustomerData);

    // Sort customer records by name
    Customer[] sortedCustomerData = check etl:sortData(uniqueCustomerData, "name", true);

    // Format phone numbers by replacing leading zeros with the country code "+94"
    Customer[] formattedCustomerData = check etl:replaceText(sortedCustomerData, "phone", re `^0+`, "+94");

    // Write the cleaned and formatted data back to a new CSV file
    check io:fileWriteCsv("./resources/preprocessed_customer_data.csv", formattedCustomerData);
}
