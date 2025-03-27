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

import ballerina/jballerina.java;
import ballerina/lang.regexp;

# Categorizes a dataset based on a numeric field and specified ranges.
# ```ballerina
# type Order record {
#    int orderId;
#    string customerName;
#    float totalAmount;
# };
# Order[] dataset = [
#     {"orderId": 1, "customerName": "Alice", "totalAmount": 5.3},
#     {"orderId": 2, "customerName": "Bob", "totalAmount": 10.5},
#     {"orderId": 3, "customerName": "John", "totalAmount": 15.0},
#     {"orderId": 4, "customerName": "Charlie", "totalAmount": 25.0},
#     {"orderId": 5, "customerName": "David", "totalAmount": 30.2}
# ];
# Order[][] categorized = check etl:categorizeNumeric(dataset, "totalAmount", [[0.0, 10.0], [10.0, 20.0]]);
#
# =>[[{"orderId": 1, "customerName": "Alice", "totalAmount": 5.3}],
#    [{"orderId": 2, "customerName": "Bob", "totalAmount": 10.5}, {"orderId": 3, "customerName": "John", "totalAmount": 15.0}],
#    [{"orderId": 4, "customerName": "Charlie", "totalAmount": 25.0}, {"orderId": 5, "customerName": "David", "totalAmount": 30.2}]]
# ```
#
# + dataset - Array of records containing numeric values.
# + fieldName - Name of the numeric field to categorize.
# + rangeArray - Array of float ranges specifying category boundaries.
# + returnType - The type of the return value (Ballerina record array).
# + return - A nested array of categorized records or an `etl:Error`.
public function categorizeNumeric(record {}[] dataset, string fieldName, float[][] rangeArray, typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCategorization"
} external;

# Categorizes a dataset based on a string field using a set of regular expressions.
# ```ballerina
# import ballerina/lang.regexp;
# type Customer record {
#     string name;
#     string city;
# };
# Customer[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "Colombo" },
#     { "name": "John", "city": "Boston" },
#     { "name": "Charlie", "city": "Los Angeles" }
# ];
# regexp:RegExp[] regexArray = [re `A.*$`, re `^B.*$`, re `^C.*$`];
# Customer[][] categorized = check etl:categorizeRegex(dataset, "city", regexArray);
#
# =>[[{ "name": "Alice", "city": "New York" }],
#    [{ "name": "Bob", "city": "Colombo" }],
#    [{ "name": "Charlie", "city": "Los Angeles" }],
#    [{ "name": "John", "city": "Boston" }]]
# ```
#
# + dataset - Array of records containing string values.
# + fieldName - Name of the string field to categorize.
# + regexArray - Array of regular expressions for matching categories.
# + returnType - The type of the return value (Ballerina record array).
# + return - A nested array of categorized records or an `etl:Error`.
public function categorizeRegex(record {}[] dataset, string fieldName, regexp:RegExp[] regexArray, typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCategorization"
} external;

# Categorizes a dataset based on a string field using semantic classification via OpenAI's GPT model.
# ```ballerina
# type Review record {
#     int id;
#     string comment;
# };
# Review[] dataset = [
#     {"id": 1, "comment": "Great service!"},
#     {"id": 2, "comment": "Terrible experience"}
#     {"id": 3, "comment": "blh blh blh"}
# ];
# Review[][] categorized = check etl:categorizeSemantic(dataset, "comment", ["Positive", "Negative"]);
#
# =>[[{"id": 1, "comment": "Great service!"}],
#    [{"id": 2, "comment": "Terrible experience"}],
#    [{"id": 3, "comment": "blh blh blh"}]]
# ```
#
# + dataset - Array of records containing textual data.
# + fieldName - Name of the field to categorize.
# + categories - Array of category names for classification.
# + modelName - Name of the Open AI model
# + returnType - The type of the return value (Ballerina record array).
# + return - A nested array of categorized records or an `etl:Error`.
public function categorizeSemantic(record {}[] dataset, string fieldName, string[] categories, string modelName = "gpt-4o", typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCategorization"
} external;
