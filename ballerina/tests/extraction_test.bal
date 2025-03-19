import ballerina/test;

type ReviewSummary record {
    string[] goodPoints;
    string[] badPoints;
    string[] improvements;
};

@test:Config {}
public function testExtractFromUnstructuredData() returns error? {
    string reviews = "The smartphone has an impressive camera and smooth performance, making it great for photography and gaming. However, the battery drains quickly, and the charging speed could be improved. The UI is intuitive, but some features feel outdated and need a refresh.";
    string[] fields = ["goodPoints", "badPoints", "improvements"];
    ReviewSummary extractedDetails = check extractFromUnstructuredData(reviews, fields);

    test:assertNotEquals(extractedDetails["goodPoints"], null);
    test:assertNotEquals(extractedDetails["badPoints"], null);
    test:assertNotEquals(extractedDetails["improvements"], null);
}
