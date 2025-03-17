import ballerina/etl;
import ballerina/io;

type CustomerDetails record {
    string customerId;
    string name;
    int age;
};

type ContactDetails record {
    string customerId;
    string city;
    string phone;
    string email;
};

public function main() returns error? {

    // Read customer details from the CSV files
    CustomerDetails[] customerDetails1 = check io:fileReadCsv("./resources/customer_details1.csv");
    CustomerDetails[] customerDetails2 = check io:fileReadCsv("./resources/customer_details2.csv");

    // Merge the two customer details arrays
    CustomerDetails[] customerDetails = check etl:mergeData([customerDetails1, customerDetails2]);

    // Read contact details from the CSV file
    ContactDetails[] contactDetails = check io:fileReadCsv("./resources/contact_details.csv");

    // Join the customer and contact details on the "customerId" field
    ContactDetails[] customers = check etl:joinData(customerDetails, contactDetails, "customerId");

    // Write the enriched data to a new CSV file
    check io:fileWriteCsv("./resources/customer_data.csv", customers);

}

