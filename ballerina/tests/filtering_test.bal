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

type Employee record {
    int id;
    string name?;
    string city?;
    int age?;
};

@test:Config {}
function testFilterDataByRatio() returns error? {
    Employee[] dataset = [
        {"id": 1, "name": "Alice"},
        {"id": 2, "name": "Bob"},
        {"id": 3, "name": "Charlie"},
        {"id": 4, "name": "David"}
    ];
    float ratio = 0.75;
    Employee[][] part = check filterDataByRatio(dataset, ratio);
    test:assertEquals(part[0].length(), check (dataset.length() * ratio).ensureType(int));
    test:assertEquals(part[1].length(), check (dataset.length() * (1.0 - ratio)).ensureType(int));
}

@test:Config {}
function testFilterDataByRegex() returns error? {
    Employee[] dataset = [
        {"id": 1, "city": "New York"},
        {"id": 2, "city": "Los Angeles"},
        {"id": 3, "city": "New Jersey"},
        {"id": 4, "city": "San Francisco"}
    ];
    string fieldName = "city";
    regexp:RegExp regexPattern = re `^New.*$`;
    Employee[] expectedMatched = [
        {"id": 1, "city": "New York"},
        {"id": 3, "city": "New Jersey"}
    ];
    Employee[] expectedNonMatched = [
        {"id": 2, "city": "Los Angeles"},
        {"id": 4, "city": "San Francisco"}
    ];
    Employee[][] result = check filterDataByRegex(dataset, fieldName, regexPattern);
    test:assertEquals(result[0], expectedMatched);
    test:assertEquals(result[1], expectedNonMatched);
}

@test:Config {}
function testFilterDataByRelativeExp() returns error? {
    Employee[] dataset = [
        {"id": 1, "name": "Alice", "age": 25},
        {"id": 2, "name": "Bob", "age": 30},
        {"id": 3, "name": "Charlie", "age": 22},
        {"id": 4, "name": "David", "age": 28}
    ];
    string fieldName = "age";
    float value = 25;
    Employee[] expectedOlderThan25 = [
        {"id": 2, "name": "Bob", "age": 30},
        {"id": 4, "name": "David", "age": 28}
    ];
    Employee[] expectedYoungerOrEqual25 = [
        {"id": 1, "name": "Alice", "age": 25},
        {"id": 3, "name": "Charlie", "age": 22}
    ];
    Employee[][] result = check filterDataByRelativeExp(dataset, fieldName, GREATER_THAN, value);
    test:assertEquals(result[0], expectedOlderThan25);
    test:assertEquals(result[1], expectedYoungerOrEqual25);
}
