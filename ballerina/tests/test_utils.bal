final readonly & Person2[] standarizedData = [
    {name: "Alice", city: "New York"},
    {name: "John", city: "New York"},
    {name: "Charlie", city: "Los Angeles"}
];

final readonly & Review[][] categorizedData = [
    [{id: 1, comment: "Great service!"}, {id: 2, comment: "Good service!"}],
    [{id: 3, comment: "Terrible experience"}]
];

final readonly & ReviewSummary extractedData = {
    goodPoints: "impressive camera, smooth performance, great for photography and gaming",
    badPoints: "battery drains quickly, charging speed could be improved",
    improvements: "features feel outdated and need a refresh"
};

final readonly & User2[] maskedData = [
    {id: 1, name: "XXXX XXX", email: "XXXXXXXXXXXXXXXX"},
    {id: 2, name: "XXXX XXXXX", email: "XXXXXXXXXXXXXXXX"},
    {id: 3, name: "XXXXX", email: "XXXXXXXXXXXXXXXXX"}
];

final readonly & Person2[][] groupedData = [
    [{name: "Bob", city: "Boston"}, {name: "John", city: "Chicago"}],
    [{name: "Charlie", city: "Los Angeles"}, {name: "charlie", city: "los angeles - usa"}]
];

isolated function getTheMockServiceResult(string message) returns string {
    if message.startsWith("Identify and replace any approximate") {
        return standarizedData.toJsonString();
    }
    if message.startsWith("Classify the given dataset") {
        return categorizedData.toJsonString();
    }
    if message.startsWith("Extract relevant details from") {
        return extractedData.toJsonString();
    }
    if message.startsWith("Personally Identifiable Information") {
        return maskedData.toJsonString();
    }
    if message.startsWith("Identify approximate duplicates") {
        return groupedData.toJsonString();
    }
    return "Invalid request";
};
