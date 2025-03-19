import ballerina/lang.regexp;
import ballerina/test;

type Order record {
    int orderId;
    string customerName;
    float totalAmount;
};

type Review record {
    int id;
    string comment;
};

@test:Config {}
function testCategorizeNumeric() returns error? {
    Order[] dataset = [
        {"orderId": 1, "customerName": "Alice", "totalAmount": 5.3},
        {"orderId": 2, "customerName": "Bob", "totalAmount": 10.5},
        {"orderId": 3, "customerName": "John", "totalAmount": 15.0},
        {"orderId": 4, "customerName": "Charlie", "totalAmount": 25.0},
        {"orderId": 5, "customerName": "David", "totalAmount": 30.2}
    ];
    string fieldName = "totalAmount";
    float[][] rangeArray = [[0.0, 10.0], [10.0, 20.0]];

    Order[][] expected = [
        [{"orderId": 1, "customerName": "Alice", "totalAmount": 5.3}],
        [{"orderId": 2, "customerName": "Bob", "totalAmount": 10.5}, {"orderId": 3, "customerName": "John", "totalAmount": 15.0}],
        [{"orderId": 4, "customerName": "Charlie", "totalAmount": 25.0}, {"orderId": 5, "customerName": "David", "totalAmount": 30.2}]
    ];

    record {}[][] categorized = check categorizeNumeric(dataset, fieldName, rangeArray);
    test:assertEquals(categorized, expected);
}

@test:Config {}
function testCategorizeRegexData() returns error? {
    Person1[] dataset = [
        {"name": "Alice", "city": "New York"},
        {"name": "Bob", "city": "Colombo"},
        {"name": "John", "city": "Boston"},
        {"name": "Charlie", "city": "Los Angeles"}
    ];
    string fieldName = "name";
    regexp:RegExp[] regexArray = [re `A.*$`, re `^B.*$`, re `^C.*$`];

    Person1[][] expected = [
        [{"name": "Alice", "city": "New York"}],
        [{"name": "Bob", "city": "Colombo"}],
        [{"name": "Charlie", "city": "Los Angeles"}],
        [{"name": "John", "city": "Boston"}]
    ];

    Person1[][] categorized = check categorizeRegex(dataset, fieldName, regexArray);
    test:assertEquals(categorized, expected);
}

@test:Config {}
function testCategorizeSemantic() returns error? {
    record {}[] dataset = [
        {"id": 1, "comment": "Great service!"},
        {"id": 2, "comment": "Good service!"},
        {"id": 3, "comment": "Terrible experience"},
        {"id": 4, "comment": "blh blh blh"}
    ];
    string fieldName = "comment";
    string[] categories = ["Positive", "Negative"];

    Review[][] expected = [
        [{"id": 1, "comment": "Great service!"}, {"id": 2, "comment": "Good service!"}],
        [{"id": 3, "comment": "Terrible experience"}],
        [{"id": 4, "comment": "blh blh blh"}]
    ];

    record {int id; string comment;}[][] categorized = check categorizeSemantic(dataset, fieldName, categories);
    test:assertEquals(categorized, expected);
}
