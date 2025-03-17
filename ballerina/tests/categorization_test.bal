import ballerina/lang.regexp;
import ballerina/test;

@test:Config {}
function testCategorizeNumeric() returns error? {
    record {}[] dataset = [
        {"value": 10.5},
        {"value": 25.0},
        {"value": 5.3},
        {"value": 15.0},
        {"value": 30.2}
    ];
    string fieldName = "value";
    float[][] rangeArray = [[0.0, 10.0], [10.0, 20.0]];

    record {}[][] expected = [
        [{"value": 5.3}],
        [{"value": 10.5}, {"value": 15.0}],
        [{"value": 25.0}, {"value": 30.2}]
    ];

    record {}[][] categorized = check categorizeNumeric(dataset, fieldName, rangeArray);
    test:assertEquals(categorized, expected);
}

@test:Config {}
function testCategorizeRegexData() returns error? {
    record {}[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Colombo"},
        {"name": "John", "city": "Boston"},
        {"name": "Charlie", "city": "Los Angeles"}
    ];
    string fieldName = "name";
    regexp:RegExp[] regexArray = [re `A.*$`, re `^B.*$`, re `^C.*$`];

    record {}[][] expected = [
        [{"name": "Alice", "city": "New York"}],
        [{"name": "Bob", "city": "Colombo"}],
        [{"name": "Charlie", "city": "Los Angeles"}],
        [{"name": "John", "city": "Boston"}]
    ];

    record {}[][] categorized = check categorizeRegex(dataset, fieldName, regexArray);
    test:assertEquals(categorized, expected);
}
