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

import ballerina/test;

type Person1 record {|
    string? name;
    string? city;
|};

type Person2 record {|
    string name;
    string city;
|};

type Person3 record {|
    string name;
    string city;
    int age?;
|};

type Person4 record {|
    string name;
    int age;
|};

type ContactDetails record {|
    string name;
    string phone;
|};

@test:Config {
    groups: ["live_tests", "mock_tests"]
}

function testGroupApproximateDuplicatess() returns error? {
    Person2[] dataset = [
        {name: "Charlie", city: "Los Angeles"},
        {name: "Bob", city: "Boston"},
        {name: "John", city: "Chicago"},
        {name: "charlie", city: "los angeles - usa"}
    ];
    Person2[][] expected = [
        [{name: "Bob", city: "Boston"},{name: "John", city: "Chicago"}],
        [{name: "Charlie", city: "Los Angeles"}, {name: "charlie", city: "los angeles - usa"}]
    ];
    OpenAICreateChatCompletionResponse mockResponse = {
        choices: [
            {
                message: {
                    content: expected.toJsonString()
                }
            }
        ]
    };
    test:prepare(openAIModel).when("chat").thenReturn(mockResponse);
    Person2[][] result = check groupApproximateDuplicates(dataset);
    test:assertEquals(result, expected);
}

@test:Config {
    groups: ["live_tests"]
}
function testHandleWhiteSpaces() returns error? {
    Person2[] dataset = [
        {name: "  Alice   ", city: "New   York  "},
        {name: "   Bob", city: "Los  Angeles  "}
    ];
    Person2[] expected = [
        {name: "Alice", city: "New York"},
        {name: "Bob", city: "Los Angeles"}
    ];
    Person2[] result = check handleWhiteSpaces(dataset);
    test:assertEquals(result, expected);
}

@test:Config {
    groups: ["live_tests"]
}
function testRemoveDuplicates() returns error? {
    Person2[] dataset = [
        {name: "Alice", city: "New York"},
        {name: "Alice", city: "New York"},
        {name: "Bob", city: "Los Angeles"}
    ];
    Person2[] expected = [
        {name: "Alice", city: "New York"},
        {name: "Bob", city: "Los Angeles"}
    ];
    Person2[] result = check removeDuplicates(dataset);
    test:assertEquals(result, expected);
}

@test:Config {
    groups: ["live_tests"]
}
function testRemoveField() returns error? {
    Person3[] dataset = [
        {name: "Alice", city: "New York", age: 30},
        {name: "Bob", city: "Los Angeles", age: 25},
        {name: "Charlie", city: "Chicago", age: 35}
    ];
    string fieldName = "age";
    Person2[] expected = [
        {name: "Alice", city: "New York"},
        {name: "Bob", city: "Los Angeles"},
        {name: "Charlie", city: "Chicago"}
    ];
    Person2[] result = check removeField(dataset, fieldName);
    test:assertEquals(result, expected);
}

@test:Config {
    groups: ["live_tests"]
}
function testRemoveEmptyValues() returns error? {
    Person1[] dataset = [
        {name: "Alice", city: "New York"},
        {name: "Bob", city: null},
        {name: "", city: "Los Angeles"},
        {name: "Charlie", city: "Boston"},
        {name: "David", city: ()}
    ];
    Person2[] expected = [
        {name: "Alice", city: "New York"},
        {name: "Charlie", city: "Boston"}
    ];
    Person2[] result = check removeEmptyValues(dataset);
    test:assertEquals(result, expected);
}

@test:Config {
    groups: ["live_tests"]
}
function testReplaceText() returns error? {

    ContactDetails[] dataset = [
        {name: "John", phone: "0718083203"},
        {name: "Doe", phone: "0718320382"}
    ];

    ContactDetails[] dataset2 = [
        {name: "John", phone: "+94718083203"},
        {name: "Doe", phone: "+94718320382"}
    ];
    ContactDetails[] result = check replaceText(dataset, "phone", re `^0+`, "+94");
    test:assertEquals(result, dataset2);

}

@test:Config {
    groups: ["live_tests"]
}
function testSort() returns error? {
    Person4[] dataset = [
        {name: "Alice", age: 25},
        {name: "Bob", age: 30},
        {name: "Charlie", age: 22}
    ];
    string fieldName = "age";
    Person4[] expected = [
        {name: "Charlie", age: 22},
        {name: "Alice", age: 25},
        {name: "Bob", age: 30}
    ];
    Person4[] result = check sortData(dataset, fieldName);
    test:assertEquals(result, expected);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testStandardizeData() returns error? {
    Person2[] dataset = [
        {name: "Alice", city: "New York"},
        {name: "John", city: "newyork - usa "},
        {name: "Charlie", city: "los-angeles"}
    ];
    string fieldName = "city";
    string[] searchValues = ["New York", "Los Angeles"];
    Person2[] expected = [
        {name: "Alice", city: "New York"},
        {name: "John", city: "New York"},
        {name: "Charlie", city: "Los Angeles"}
    ];
    OpenAICreateChatCompletionResponse mockResponse = {
        choices: [
            {
                message: {
                    content: expected.toJsonString()
                }
            }
        ]
    };
    test:prepare(openAIModel).when("chat").thenReturn(mockResponse);
    Person2[] result = check standardizeData(dataset, fieldName, searchValues);
    test:assertEquals(result, expected);
}
