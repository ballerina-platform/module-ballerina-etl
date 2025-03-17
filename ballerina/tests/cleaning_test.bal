import ballerina/test;

type Customer record {
    string name;
    string phone;
};

@test:Config {}
function testRemoveNull() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": null},
        {"name": "Charlie", "city": ""}
    ];
    record {}[] expected = [
        {"name": "Alice", "city": "New York"}
    ];

    record {}[] result = check removeNull(dataset);
    test:assertEquals(result, expected);
}

@test:Config {}
function testRemoveDuplicates() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"},
        {"name": "Alice", "city": "New York"}
    ];
    record {}[] expected = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"}
    ];

    record {}[] result = check removeDuplicates(dataset);
    test:assertEquals(result, expected);
}

@test:Config {}
function testRemoveField() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "city": "New York", "age": 30},
        {"name": "Bob", "city": "Los Angeles", "age": 25},
        {"name": "Charlie", "city": "Chicago", "age": 35}
    ];
    string fieldName = "age";
    record {}[] expected = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"},
        {"name": "Charlie", "city": "Chicago"}
    ];

    record {}[] result = check removeField(dataset, fieldName);
    test:assertEquals(result, expected);
}

@test:Config {}
function testReplaceText() returns error? {

    Customer[] dataset = [
        {name: "John", phone: "0718083203"},
        {name: "Doe", phone: "0718320382"}
    ];

    Customer[] dataset2 = [
        {name: "John", phone: "+94718083203"},
        {name: "Doe", phone: "+94718320382"}
    ];
    Customer[] result = check replaceText(dataset, "phone", re `^0+`, "+94");
    test:assertEquals(result, dataset2);

}

@test:Config {}
function testSort() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "age": 25},
        {"name": "Bob", "age": 30},
        {"name": "Charlie", "age": 22}
    ];
    string fieldName = "age";
    boolean isAscending = true;
    record {}[] expected = [
        {"name": "Charlie", "age": 22},
        {"name": "Alice", "age": 25},
        {"name": "Bob", "age": 30}
    ];

    record {}[] result = check sortData(dataset, fieldName, isAscending);
    test:assertEquals(result, expected);
}

@test:Config {}
function testHandleWhiteSpaces() returns error? {
    record {}[] dataset = [
        {"name": "  Alice   ", "city": "New   York  "},
        {"name": "   Bob", "city": "Los  Angeles  "}
    ];
    record {}[] expected = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Los Angeles"}
    ];

    record {}[] result = check handleWhiteSpaces(dataset);
    test:assertEquals(result, expected);
}
