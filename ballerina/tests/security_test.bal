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

type User1 record {|
    int id;
    string name;
    string|int age;
|};

type User2 record {|
    int id;
    string name;
    string email;
|};

@test:Config {}
function testDecryptData() returns error? {
    User1[] encryptedData = [
        {id: 1, name: "A86md8hKcPxPtyHOaFGkVA==", age: "uo//698HbSwcKIGSNkhpwQ=="},
        {id: 2, name: "DWyJ/vwgiiRckHNvAYD98Q==", age: "eRy1rD0U00pDhzK/IrE+ig=="}
    ];
    byte[16] key = [78, 45, 73, 76, 56, 73, 116, 116, 72, 70, 105, 108, 97, 110, 65, 100];
    User1[] expectedDecryptedData = [
        {id: 1, name: "Alice", age: "25"},
        {id: 2, name: "Bob", age: "30"}
    ];
    User1[] decryptedData = check decryptData(encryptedData, ["name", "age"], key);
    test:assertEquals(decryptedData, expectedDecryptedData);
}

@test:Config {}
function testEncryptData() returns error? {
    User1[] dataset = [
        {id: 1, name: "Alice", age: 25},
        {id: 2, name: "Bob", age: 30}
    ];
    User1[] expectedEncryptedData = [
        {id: 1, name: "A86md8hKcPxPtyHOaFGkVA==", age: "uo//698HbSwcKIGSNkhpwQ=="},
        {id: 2, name: "DWyJ/vwgiiRckHNvAYD98Q==", age: "eRy1rD0U00pDhzK/IrE+ig=="}
    ];
    byte[16] key = [78, 45, 73, 76, 56, 73, 116, 116, 72, 70, 105, 108, 97, 110, 65, 100];
    User1[] encryptedData = check encryptData(dataset, ["name", "age"], key);
    test:assertEquals(encryptedData, expectedEncryptedData);
}

@test:Config {}
function testMaskSensitiveData() returns error? {
    User2[] dataset = [
        {id: 1, name: "John Doe", email: "john@example.com"},
        {id: 2, name: "Jane Smith", email: "jane@example.com"},
        {id: 3, name: "Alice", email: "alice@example.com"}
    ];
    User2[] expected = [
        {id: 1, name: "XXXX XXX", email: "XXXXXXXXXXXXXXXX"},
        {id: 2, name: "XXXX XXXXX", email: "XXXXXXXXXXXXXXXX"},
        {id: 3, name: "XXXXX", email: "XXXXXXXXXXXXXXXXX"}
    ];
    User2[] maskedData = check maskSensitiveData(dataset);
    test:assertEquals(maskedData, expected);
}
