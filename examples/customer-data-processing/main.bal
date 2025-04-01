// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/etl;
import ballerina/io;
import ballerina/log;

type RawCustomerDetails record {|
    string id;
    string? name;
    int? age?;
    string? city;
    string? contactNumber;
    string? email;
|};

type CustomerDetails record {|
    string id;
    string name;
    string city;
    string contactNumber;
    string email;
|};

type CustomerPreferences record {|
    string id;
    string preferredCategory;
    string membershipTier;
    int annualSpending;
    string preferredContactMethod;
    string maritalStatus;
    string occupation;
|};

type CustomerData record {|
    string id;
    string name;
    string city;
    string contactNumber;
    string email;
    string preferredCategory;
    string membershipTier;
    int annualSpending;
    string preferredContactMethod;
    string maritalStatus;
    string occupation;
|};

public function main() returns error? {

    log:printInfo("Extracting customer data...");
    RawCustomerDetails[] customers = check io:fileReadCsv("resources/customer_details.csv");
    CustomerPreferences[] preferences = check io:fileReadCsv("resources/customer_preferences.csv");
    log:printInfo("Extraction completed.");

    log:printInfo("Cleaning customer data...");
    RawCustomerDetails[] cleanedCustomers = check etl:removeField(customers, "age");
    RawCustomerDetails[] trimmedCustomers = check etl:handleWhiteSpaces(cleanedCustomers);
    CustomerDetails[] nonNullCustomers = check etl:removeEmptyValues(trimmedCustomers);
    CustomerDetails[] uniqueCustomers = check etl:removeDuplicates(nonNullCustomers);
    CustomerDetails[] formattedCustomers = check etl:replaceText(uniqueCustomers, "contactNumber", re `^0+`, "+94");
    CustomerDetails[] sortedCustomers = check etl:sortData(formattedCustomers, "id");
    log:printInfo("Cleaning completed.");

    log:printInfo("Validating customer...");
    CustomerDetails[] validCustomers = check etl:filterDataByRegex(sortedCustomers, "email", re `[A-Za-z0-9\._%+-]+@[A-Za-z0-9\.-]+\.[A-Za-z]{2,}`);
    log:printInfo("Validation completed.");

    log:printInfo("Enriching customer data...");
    CustomerData[] customerData = check etl:joinData(validCustomers, preferences, "id");
    log:printInfo("Enrichment completed.");

    log:printInfo("Masking sensitive data...");
    CustomerData[] maskedCustomerData = check etl:maskSensitiveData(customerData);
    log:printInfo("Masking completed.");

    log:printInfo("Categorizing customers...");
    CustomerData[][] categorizedCustomers = check etl:categorizeRegex(maskedCustomerData, "membershipTier", [re `Gold`, re `Silver`, re `Bronze`]);
    log:printInfo("Categorization completed.");

    log:printInfo("Loading customer data...");
    check io:fileWriteCsv("resources/categories/gold_customers.csv", categorizedCustomers[0]);
    check io:fileWriteCsv("resources/categories/silver_customers.csv", categorizedCustomers[1]);
    check io:fileWriteCsv("resources/categories/bronze_customers.csv", categorizedCustomers[2]);
    log:printInfo("Loading completed.");

}
