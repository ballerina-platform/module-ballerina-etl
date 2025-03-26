// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/etl;
import ballerina/io;
import ballerina/log;

type UserFeedback record {|
    string userId;
    string brandName;
    string comment;
|};

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
