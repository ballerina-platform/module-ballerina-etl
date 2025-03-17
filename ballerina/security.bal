import ballerina/jballerina.java;

# Encrypts specific fields of a dataset using AES-ECB encryption with a given Base64-encoded key.
#
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "Alice", "age": 25 },
#     { "id": 2, "name": "Bob", "age": 30 }
# ];
# string[] fieldNames = ["name", "age"];
# string keyBase64 = "aGVsbG9zZWNyZXRrZXkxMjM0NTY=";
# record {}[] encryptedData = check etl:encryptData(dataset, fieldNames, keyBase64);
# ```
#
# + dataset - The dataset containing records where specific fields need encryption.
# + fieldNames - An array of field names that should be encrypted.
# + keyBase64 - The AES encryption key in Base64 format.
# + returnType - The type of the return value (Ballerina record ).
# + return - A dataset with specified fields encrypted using AES-ECB and Base64-encoded.
public function encryptData(record {}[] dataset, string[] fieldNames, string keyBase64, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlSecurity"
} external;

# Decrypts specific fields of a dataset using AES-ECB decryption with a given Base64-encoded key.
#
# ```ballerina
# record {}[] encryptedDataset = [
#     { "name": "U2FtcGxlTmFtZQ==", "age": "MjU=" },
#     { "name": "Qm9i", "age": "MzA=" }
# ];
# string[] fieldNames = ["name", "age"];
# string keyBase64 = "aGVsbG9zZWNyZXRrZXkxMjM0NTY=";
# record {}[] decryptedData = check etl:decryptData(encryptedDataset, fieldNames, keyBase64);
# ```
#
# + dataset - The dataset containing records with Base64-encoded encrypted fields.
# + fieldNames - An array of field names that should be decrypted.
# + keyBase64 - The AES decryption key in Base64 format.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset with the specified fields decrypted.
public function decryptData(record {}[] dataset, string[] fieldNames, string keyBase64, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlSecurity"
} external;
