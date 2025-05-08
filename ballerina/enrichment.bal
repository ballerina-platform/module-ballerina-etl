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

# Merges two datasets based on a common specified field and returns a new dataset with the merged records.
# ```ballerina
# CustomerPersonalDetails[] dataset1 = [{ id: 1, name: "Alice" }, { id: 2, name: "Bob" }];
# CustomerContactDetails[] dataset2 = [{ id: 1, phone: 0123456789 }, { id: 2, phone: 0987654321 }];
# Customer[] mergedData = check etl:joinData(dataset1, dataset2, "id");
#
# => [{ id: 1, name: "Alice", phone: 0123456789 },
#     { id: 2, name: "Bob", phone: 0987654321 }]
# ```
#
# + dataset1 - First dataset containing base records.
# + dataset2 - Second dataset with additional data to be merged.
# + fieldName - The field used to match records between the datasets.
# + returnType - The type of the return value (Ballerina record).
# + return - A merged dataset with updated records or an `etl:Error`.
public function joinData(record {}[] dataset1, record {}[] dataset2, string fieldName, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlEnrichment"
} external;

# Merges multiple datasets into a single dataset by flattening a nested array of records.
# ```ballerina
# Customer[][] dataSets = [
#     [{ id: 1, name: "Alice" }, { id: 2, name: "Bob" }],
#     [{ id: 3, name: "Charlie" }, { id: 4, name: "David" }]
# ];
# Customer[] mergedData = check etl:mergeData(dataSets);
#
# => [{ id: 1, name: "Alice" },
#     { id: 2, name: "Bob" },
#     { id: 3, name: "Charlie" },
#     { id: 4, name: "David" }]
# ```
#
# + datasets - An array of datasets, where each dataset is an array of records.
# + returnType - The type of the return value (Ballerina record).
# + return - A single merged dataset containing all records or an `etl:Error`.
public function mergeData(record {}[][] datasets, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlEnrichment"
} external;
