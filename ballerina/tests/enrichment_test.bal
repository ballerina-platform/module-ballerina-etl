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

type Customer record {|
    int id;
    string name?;
    int age?;
|};

@test:Config {}
function testJoinData() returns error? {
    Customer[] dataset1 = [
        {"id": 1, "name": "Alice"},
        {"id": 2, "name": "Bob"}
    ];
    Customer[] dataset2 = [
        {"id": 1, "age": 25},
        {"id": 2, "age": 30}
    ];
    string primaryKey = "id";
    record {}[] expected = [
        {"id": 1, "name": "Alice", "age": 25},
        {"id": 2, "name": "Bob", "age": 30}
    ];
    record {}[] mergedData = check joinData(dataset1, dataset2, primaryKey);
    test:assertEquals(mergedData, expected);
}

@test:Config {}
function testMergeData() returns error? {
    record {}[][] dataSets = [
        [{"id": 1, "name": "Alice"}, {"id": 2, "name": "Bob"}],
        [{"id": 3, "name": "Charlie"}, {"id": 4, "name": "David"}]
    ];
    record {}[] expected = [
        {"id": 1, "name": "Alice"},
        {"id": 2, "name": "Bob"},
        {"id": 3, "name": "Charlie"},
        {"id": 4, "name": "David"}
    ];
    record {}[] mergedData = check mergeData(dataSets);
    test:assertEquals(mergedData, expected);
}
