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

# Decrypts specific fields of a dataset using AES-ECB decryption with a given Base64-encoded key.
#
# ```ballerina
# type Customer record {
#     string name;
#     int age;
# };
# Customer[] encryptedDataset = [
#     { "name": "kHKa63v98rbDm+FB2DJ3ig==", "age": 23 },
#     { "name": "S0x+hpmvSOIT7UE8hOGZkA==", "age": 35 }
# ];
# string keyBase64 = "TgMtILI4IttHFilanAdZbw==";
# Customer[] decryptedData = check etl:decryptData(encryptedDataset, ["name"], keyBase64);
#
# => [{ "name": "Alice", "age": 23 },
#     { "name": "Bob", "age": 35 }]
# ```
#
# + dataset - The dataset containing records with Base64-encoded encrypted fields.
# + fieldNames - An array of field names that should be decrypted.
# + keyBase64 - The AES decryption key in Base64 format.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset with the specified fields decrypted or an `etl:Error`.
public function decryptData(record {}[] dataset, string[] fieldNames, string keyBase64, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlSecurity"
} external;

# Encrypts specific fields of a dataset using AES-ECB encryption with a given Base64-encoded key.
#
# ```ballerina
# type Customer record {
#     string name;
#     int age;
# };
# Customer[] dataset = [
#     { "id": 1, "name": "Alice", "age": 25 },
#     { "id": 2, "name": "Bob", "age": 30 }
# ];
# string keyBase64 = "TgMtILI4IttHFilanAdZbw==";
# Customer[] encryptedData = check etl:encryptData(dataset, ["name"], keyBase64);
#
# =>[{"id": 1, "name": "kHKa63v98rbDm+FB2DJ3ig==", "age": 25 },
#    {"id": 2, "name": "S0x+hpmvSOIT7UE8hOGZkA==", "age": 30 }]
# ```
#
# + dataset - The dataset containing records where specific fields need encryption.
# + fieldNames - An array of field names that should be encrypted.
# + keyBase64 - The AES encryption key in Base64 format.
# + returnType - The type of the return value (Ballerina record ).
# + return - A dataset with specified fields encrypted and Base64-encoded or an `etl:Error`.
public function encryptData(record {}[] dataset, string[] fieldNames, string keyBase64, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlSecurity"
} external;

# Masks specified fields of a dataset by replacing each character in the sensitive fields with a default masking character.
#
# This function sends a request to the GPT-4 API to identify fields in the dataset that contain Personally Identifiable Information (PII),
# and replaces all characters in those fields with the default masking character 'X'.
#
# ```ballerina
# type Customer record {
#    int id;
#    string name;
#    string email;
# };
# Customer[] dataset = [
#     { "id": 1, "name": "John Doe", "email": "john@example.com" },
#     { "id": 2, "name": "Jane Smith", "email": "jane@example.com" }
# ];
# Customer[] maskedData = check etl:maskSensitiveData(dataset);
#
# => [{ "id": 1, "name": "XXX XXX", "email": "XXXXXXXXXXXXXXX" },
#     { "id": 2, "name": "XXXX XXXX", "email": "XXXXXXXXXXXXXXX" }]
# ```
#
# + dataset - The dataset containing records where sensitive fields should be masked.
# + modelName - The name of the GPT model to use for identifying PII. Default is "gpt-4o".
# + maskingCharacter - The character to use for masking sensitive fields. Default is 'X'.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset where the specified fields containing PII are masked with the given masking character or an `etl:Error`.
public function maskSensitiveData(record {}[] dataset, string:Char maskingCharacter = "X", string modelName = "gpt-4o", typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlSecurity"
} external;
