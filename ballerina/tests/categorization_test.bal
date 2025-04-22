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

import ballerina/lang.regexp;
import ballerina/test;

type Order record {|
    int orderId;
    string customerName;
    float totalAmount;
|};

type Review record {|
    int id;
    string comment;
|};

@test:Config {
    groups: ["live_tests"]
}
function testCategorizeNumeric() returns error? {
    Order[] dataset = [
        {orderId: 1, customerName: "Alice", totalAmount: 5.3},
        {orderId: 2, customerName: "Bob", totalAmount: 10.5},
        {orderId: 3, customerName: "John", totalAmount: 15.0},
        {orderId: 4, customerName: "Charlie", totalAmount: 25.0},
        {orderId: 5, customerName: "David", totalAmount: 29}
    ];
    string fieldName = "totalAmount";
    CategoryRanges categoryRanges = [0, [10, 20], 30];
    Order[][] expected = [
        [{orderId: 1, customerName: "Alice", totalAmount: 5.3}],
        [{orderId: 2, customerName: "Bob", totalAmount: 10.5}, {orderId: 3, customerName: "John", totalAmount: 15.0}],
        [{orderId: 4, customerName: "Charlie", totalAmount: 25.0}, {orderId: 5, customerName: "David", totalAmount: 29}]
    ];
    Order[][] categorized = check categorizeNumeric(dataset, fieldName, categoryRanges);
    test:assertEquals(categorized, expected);
}

@test:Config {
    groups: ["live_tests"]
}
function testCategorizeRegexData() returns error? {
    Person1[] dataset = [
        {name: "Alice", city: "New York"},
        {name: "Bob", city: "Colombo"},
        {name: "John", city: "Boston"},
        {name: "Charlie", city: "Los Angeles"}
    ];
    string fieldName = "name";
    regexp:RegExp[] regexArray = [re `A.*$`, re `^B.*$`, re `^C.*$`];
    Person1[][] expected = [
        [{name: "Alice", city: "New York"}],
        [{name: "Bob", city: "Colombo"}],
        [{name: "Charlie", city: "Los Angeles"}]
    ];
    Person1[][] categorized = check categorizeRegex(dataset, fieldName, regexArray);
    test:assertEquals(categorized, expected);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCategorizeSemantic() returns error? {
    Review[] dataset = [
        {id: 1, comment: "Great service!"},
        {id: 2, comment: "Good service!"},
        {id: 3, comment: "Terrible experience"}
    ];
    string fieldName = "comment";
    string[] categories = ["Positive", "Negative"];
    Review[][] expected = [
        [{id: 1, comment: "Great service!"}, {id: 2, comment: "Good service!"}],
        [{id: 3, comment: "Terrible experience"}]
    ];
    Review[][] categorized = check categorizeSemantic(dataset, fieldName, categories);
    test:assertEquals(categorized, expected);
}
