import ballerina/lang.regexp;
import ballerina/test;

@test:Config {}
function testFilterDataByRatio() returns error? {
    record {}[] dataset = [
        {"id": 1, "name": "Alice"},
        {"id": 2, "name": "Bob"},
        {"id": 3, "name": "Charlie"},
        {"id": 4, "name": "David"}
    ];
    float ratio = 0.75;
    record {}[][] part = check filterDataByRatio(dataset, ratio);
    test:assertEquals(part[0].length(), check (dataset.length() * ratio).ensureType(int));
    test:assertEquals(part[1].length(), check (dataset.length() * (1.0 - ratio)).ensureType(int));
}

@test:Config {}
function testFilterDataByRegex() returns error? {
    record {}[] dataset = [
        {"id": 1, "city": "New York"},
        {"id": 2, "city": "Los Angeles"},
        {"id": 3, "city": "Newark"},
        {"id": 4, "city": "San Francisco"}
    ];
    string fieldName = "city";
    regexp:RegExp regexPattern = re `^New.*$`;
    record {}[] expectedMatched = [
        {"id": 1, "city": "New York"},
        {"id": 3, "city": "Newark"}
    ];
    record {}[] expectedNonMatched = [
        {"id": 2, "city": "Los Angeles"},
        {"id": 4, "city": "San Francisco"}
    ];
    record {}[][] result = check filterDataByRegex(dataset, fieldName, regexPattern);
    test:assertEquals(result[0], expectedMatched);
    test:assertEquals(result[1], expectedNonMatched);
}

@test:Config {}
function testFilterDataByRelativeExp() returns error? {
    record {}[] dataset = [
        {"id": 1, "name": "Alice", "age": 25},
        {"id": 2, "name": "Bob", "age": 30},
        {"id": 3, "name": "Charlie", "age": 22},
        {"id": 4, "name": "David", "age": 28}
    ];
    string fieldName = "age";
    float value = 25;
    record {}[] expectedOlderThan25 = [
        {"id": 2, "name": "Bob", "age": 30},
        {"id": 4, "name": "David", "age": 28}
    ];
    record {}[] expectedYoungerOrEqual25 = [
        {"id": 1, "name": "Alice", "age": 25},
        {"id": 3, "name": "Charlie", "age": 22}
    ];
    record {}[][] result = check filterDataByRelativeExp(dataset, fieldName, GREATER_THAN, value);
    test:assertEquals(result[0], expectedOlderThan25);
    test:assertEquals(result[1], expectedYoungerOrEqual25);
}
