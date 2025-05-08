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

import ballerina/jballerina.java;

# Extracts structured data from a raw text input and maps it to a Ballerina record.
# ```ballerina
# type Review record{|
#     string goodPoints;
#     string badPoints;
#     string improvements;
# |};
#
# string reviews = "The smartphone has an impressive camera and smooth performance, making it great for photography and gaming. However, the battery drains quickly, and the charging speed could be improved. The UI is intuitive, but some features feel outdated and need a refresh.";
# Review extractedDetails = check etl:extractFromText(reviews);
#
# => { goodPoints: "The smartphone has an impressive camera and smooth performance, making it great for photography and gaming.",
#      badPoints: "However, the battery drains quickly, and the charging speed could be improved.",
#      improvements: "The UI is intuitive, but some features feel outdated and need a refresh." }
# ```
#
# + sourceText - The raw text input from which structured data is to be extracted.
# + returnType - The type of the return value (Ballerina record).
# + return - A record with extracted details mapped to the specified field names or an `etl:Error`.
public function extractFromText(string sourceText, typedesc<record {}> returnType = <>) returns returnType|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlExtraction"
} external;
