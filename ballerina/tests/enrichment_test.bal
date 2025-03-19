import ballerina/test;

type Customer record {
    int id;
    string name?;
    int age?;
};

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
