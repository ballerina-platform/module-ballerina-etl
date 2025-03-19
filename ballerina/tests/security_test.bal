import ballerina/test;

type User1 record {
    int id;
    string name;
    string|int age;
};

type User2 record {
    int id;
    string name;
    string email;
};

@test:Config {}
function testDecryptData() returns error? {
    User1[] encryptedData = [
        {"id": 1, "name": "kHKa63v98rbDm+FB2DJ3ig==", "age": "DwknVxmigukb2VBkDj2rHg=="},
        {"id": 2, "name": "S0x+hpmvSOIT7UE8hOGZkA==", "age": "goBjsnnKAMRoEfkZsbRYwg=="}
    ];
    string keyBase64 = "TgMtILI4IttHFilanAdZbw==";

    User1[] expectedDecryptedData = [
        {"id": 1, "name": "Alice", "age": "25"},
        {"id": 2, "name": "Bob", "age": "30"}
    ];

    User1[] decryptedData = check decryptData(encryptedData, ["name", "age"], keyBase64);
    test:assertEquals(decryptedData, expectedDecryptedData);
}

@test:Config {}
function testEncryptData() returns error? {
    User1[] dataset = [
        {"id": 1, "name": "Alice", "age": 25},
        {"id": 2, "name": "Bob", "age": 30}
    ];
    string keyBase64 = "TgMtILI4IttHFilanAdZbw==";

    User1[] encryptedData = check encryptData(dataset, ["name", "age"], keyBase64);
    test:assertEquals(encryptedData.length(), dataset.length());
}

@test:Config {}
function testMaskSensitiveData() returns error? {
    User2[] dataset = [
        {"id": 1, "name": "John Doe", "email": "john@example.com"},
        {"id": 2, "name": "Jane Smith", "email": "jane@example.com"},
        {"id": 3, "name": "Alice", "email": "alice@example.com"}
    ];

    User2[] maskedData = check maskSensitiveData(dataset);
    test:assertEquals(maskedData.length(), dataset.length());
    test:assertTrue(maskedData.every(data => data.name.includes("X") && data.email.includes("X")));
}
