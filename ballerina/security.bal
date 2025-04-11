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
# Customer[] encryptedDataset = [
#     { name: "kHKa63v98rbDm+FB2DJ3ig==", age: 23 },
#     { name: "S0x+hpmvSOIT7UE8hOGZkA==", age: 35 }
# ];
# byte[16] key = [78, 45, 73, 76, 56, 73, 116, 116, 72, 70, 105, 108, 97, 110, 65, 100];
# DecryptedCustomer[] decryptedData = check etl:decryptData(encryptedDataset, ["name"], key);
#
# => [{ name: "Alice", age: 23 },
#     { name: "Bob", age: 35 }]
# ```
#
# + dataset - The dataset containing records with Base64-encoded encrypted fields.
# + fieldNames - An array of field names that should be decrypted.
# + key - The AES decryption key in byte array format.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset with the specified fields decrypted or an `etl:Error`.
public function decryptData(record {}[] dataset, string[] fieldNames, byte[16] key, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlSecurity"
} external;

# Encrypts specific fields of a dataset using AES-ECB encryption with a given Base64-encoded key.
#
# ```ballerina
# Customer[] dataset = [
#     { id: 1, name: "Alice", age: 25 },
#     { id: 2, name: "Bob", age: 30 }
# ];
# byte[16] key = [78, 45, 73, 76, 56, 73, 116, 116, 72, 70, 105, 108, 97, 110, 65, 100];
# EncryptedCustomer[] encryptedData = check etl:encryptData(dataset, ["name"], key);
#
# =>[{ id: 1, name: "kHKa63v98rbDm+FB2DJ3ig==", age: 25 },
#    { id: 2, name: "S0x+hpmvSOIT7UE8hOGZkA==", age: 30 }]
# ```
#
# + dataset - The dataset containing records where specific fields need encryption.
# + fieldNames - An array of field names that should be encrypted.
# + key - The AES encryption key in byte array format.
# + returnType - The type of the return value (Ballerina record ).
# + return - A dataset with specified fields encrypted and Base64-encoded or an `etl:Error`.
public function encryptData(record {}[] dataset, string[] fieldNames, byte[16] key, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlSecurity"
} external;

# Masks specified fields of a dataset by replacing each character in the sensitive fields with a default masking character.
#
# ```ballerina
# Customer[] dataset = [
#     { id: 1, name: "John Doe", email: "john@example.com" },
#     { id: 2, name: "Jane Smith", email: "jane@example.com" }
# ];
# MaskedCustomer[] maskedData = check etl:maskSensitiveData(dataset);
#
# => [{ id: 1, name: "XXX XXX", email: "XXXXXXXXXXXXXXX" },
#     { id: 2, name: "XXXX XXXX", email: "XXXXXXXXXXXXXXX" }]
# ```
#
# + dataset - The dataset containing records where sensitive fields should be masked.
# + maskingCharacter - The character to use for masking sensitive fields. Default is 'X'.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset where the specified fields containing PII are masked with the given masking character or an `etl:Error`.
public function maskSensitiveData(record {}[] dataset, string:Char maskingCharacter = "X", typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlSecurity"
} external;
