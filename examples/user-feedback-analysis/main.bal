import ballerina/etl;
import ballerina/io;
import ballerina/log;

type UserFeedback record {
    string userId;
    string brandName;
    string comment;
};

public function main() returns error? {

    log:printInfo("Extracting user feedbacks...");
    UserFeedback[] userFeedbacks = [];
    string[] feedbacks = check io:fileReadLines("resources/feedbacks.txt");
    foreach string feedback in feedbacks {
        UserFeedback userFeedback = check etl:extractFromUnstructuredData(feedback, ["userId", "brandName", "comment"]);
        userFeedbacks.push(userFeedback);
        log:printInfo(string `Extracted user feedback for user ID:${userFeedback.userId}`);
    }
    log:printInfo(string `Extracted ${userFeedbacks.length()} user feedbacks`);

    log:printInfo("Standardizing brand names..");
    UserFeedback[] standardizeFeedbacks = check etl:standardizeData(userFeedbacks, "brandName", ["NeoBook Pro", "XenPhone X", "FlexFit Pro", "EchoBuds 3", "FusionBlend 500"]);
    log:printInfo("Standardization completed");

    log:printInfo("Categorizing feedbacks...");
    UserFeedback[][] categorizedFeedbacks = check etl:categorizeSemantic(standardizeFeedbacks, "comment", ["Positive", "Negative"]);
    log:printInfo("Categorization completed");

    log:printInfo("Loading categorized feedbacks to CSV files...");
    check io:fileWriteCsv("resources/positive_feedbacks.csv", categorizedFeedbacks[0]);
    check io:fileWriteCsv("resources/negative_feedbacks.csv", categorizedFeedbacks[1]);
    log:printInfo("Loading completed");

}
