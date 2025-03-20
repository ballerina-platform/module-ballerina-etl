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

type Person1 record {
    string? name?;
    string? phone?;
    string? city?;
    int? age?;
};

type Person2 record {
    string name;
    string city;
};

@test:Config {}
function testGroupApproximateDuplicatess() returns error? {
    Person2[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Boston"},
        {"name": "John", "city": "Chicago"},
        {"name": "Alice", "city": "new york"},
        {"name": "Charlie", "city": "Los Angeles"},
        {"name": "charlie", "city": "los angeles - usa"}
    ];

    Person2[] uniqueRecords = [
        {"name": "Bob", "city": "Boston"},
        {"name": "John", "city": "Chicago"}
    ];
    Person2[][] duplicateGroups = [
        [{"name": "Alice", "city": "New York"}, {"name": "Alice", "city": "new york"}],
        [{"name": "Charlie", "city": "Los Angeles"}, {"name": "charlie", "city": "los angeles - usa"}]
    ];

    Person2[][] result = check groupApproximateDuplicates(dataset);
    test:assertEquals(result[0], uniqueRecords);
    test:assertEquals(result.slice(1), duplicateGroups);

}

@test:Config {}
function testHandleWhiteSpaces() returns error? {
    Person1[] dataset = [
        {"name": "  Alice   ", "city": "New   York  "},
        {"name": "   Bob", "city": "Los  Angeles  "}
    ];
    Person1[] expected = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"}
    ];

    Person1[] result = check handleWhiteSpaces(dataset);
    test:assertEquals(result, expected);
}

@test:Config {}
function testRemoveDuplicates() returns error? {
    Person1[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"},
        {"name": "Alice", "city": "New York"}
    ];
    Person1[] expected = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"}
    ];
    Person1[] result = check removeDuplicates(dataset);
    test:assertEquals(result, expected);
}

@test:Config {}
function testRemoveField() returns error? {
    Person1[] dataset = [
        {"name": "Alice", "city": "New York", "age": 30},
        {"name": "Bob", "city": "Los Angeles", "age": 25},
        {"name": "Charlie", "city": "Chicago", "age": 35}
    ];
    string fieldName = "age";
    Person1[] expected = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"},
        {"name": "Charlie", "city": "Chicago"}
    ];

    Person1[] result = check removeField(dataset, fieldName);
    test:assertEquals(result, expected);
}

@test:Config {}
function testRemoveNull() returns error? {
    Person1[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": null},
        {"name": "Charlie", "city": ""}
    ];
    Person1[] expected = [
        {"name": "Alice", "city": "New York"}
    ];
    Person1[] result = check removeNull(dataset);
    test:assertEquals(result, expected);
}

@test:Config {}
function testReplaceText() returns error? {

    Person1[] dataset = [
        {name: "John", phone: "0718083203"},
        {name: "Doe", phone: "0718320382"}
    ];

    Person1[] dataset2 = [
        {name: "John", phone: "+94718083203"},
        {name: "Doe", phone: "+94718320382"}
    ];
    Person1[] result = check replaceText(dataset, "phone", re `^0+`, "+94");
    test:assertEquals(result, dataset2);

}

@test:Config {}
function testSort() returns error? {
    Person1[] dataset = [
        {"name": "Alice", "age": 25},
        {"name": "Bob", "age": 30},
        {"name": "Charlie", "age": 22}
    ];
    string fieldName = "age";
    boolean isAscending = true;
    Person1[] expected = [
        {"name": "Charlie", "age": 22},
        {"name": "Alice", "age": 25},
        {"name": "Bob", "age": 30}
    ];

    Person1[] result = check sortData(dataset, fieldName, isAscending);
    test:assertEquals(result, expected);
}

@test:Config {}
function testStandardizeData() returns error? {
    Person2[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "John", "city": "new york"},
        {"name": "Charlie", "city": "Los Angeles"}
    ];
    string fieldName = "city";
    string searchValue = "New York";
    Person2[] expected = [
        {"name": "Alice", "city": "New York"},
        {"name": "John", "city": "New York"},
        {"name": "Charlie", "city": "Los Angeles"}
    ];

    Person2[] result = check standardizeData(dataset, fieldName, searchValue);
    test:assertEquals(result, expected);
}
