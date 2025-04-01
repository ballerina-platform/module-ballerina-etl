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
import ballerina/lang.regexp;

# Filters a random set of records from a dataset based on a specified ratio.
# ```ballerina
# Customer[] dataset = [
#     { id: 1, name: "Alice" },
#     { id: 2, name: "Bob" },
#     { id: 3, name: "Charlie" },
#     { id: 4, name: "David" }
# ];
# Customer[] filteredDataset = check etl:filterDataByRatio(dataset, 0.75);
#
# => [{ id: 4, name: "David" }, { id: 2, name: "Bob" }, { id: 3, name: "Charlie" }]
# ```
#
# + dataset - Array of records to be split.
# + ratio - The ratio for splitting the dataset (e.g., `0.75` means 75% in the first set).
# + returnType - The type of the return value (Ballerina record array).
# + return - Filtered dataset containing a random subset of records or an `etl:Error`.
public function filterDataByRatio(record {}[] dataset, float ratio, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlFiltering"
} external;

# Filters a dataset into two subsets based on a regex pattern match.
# ```ballerina
# Customer[] dataset = [
#     { id: 1, city: "New York" },
#     { id: 2, city: "Los Angeles" },
#     { id: 3, city: "San Francisco" }
# ];
# string fieldName = "city";
# regexp:RegExp regexPattern = re `^New.*$`;
# Customer[] filteredDataset = check etl:filterDataByRegex(dataset, "city", regexPattern);
#
# => [{ id: 1, city: "New York"}]
# ```
#
# + dataset - Array of records to be filtered.
# + fieldName - Name of the field to apply the regex filter.
# + regexPattern - Regular expression to match values in the field.
# + returnType - The type of the return value (Ballerina record array).
# + return - Filtered dataset containing records that match the regex pattern or an `etl:Error`.
public function filterDataByRegex(record {}[] dataset, string fieldName, regexp:RegExp regexPattern, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlFiltering"
} external;

# Filters a dataset based on a relative numeric comparison expression.
#
# ```ballerina
# Customer[] dataset = [
#     { id: 1, name: "Alice", age: 25 },
#     { id: 2, name: "Bob", age: 30 },
#     { id: 3, name: "Charlie", age: 22 },
#     { id: 4, name: "David", age: 28 }
# ];
# Customer[] filteredDataset = check etl:filterDataByRelativeExp(dataset, "age", etl:GREATER_THAN, 25);
#
# => [{ id: 2, name: "Bob", age: 30}, {id: 4, name: "David", age: 28}]
# ```
#
# + dataset - Array of records containing numeric fields for comparison.
# + fieldName - Name of the field to evaluate.
# + operation - Comparison operation to apply as `etl:Operation`.
# + value - Numeric value to compare against.
# + returnType - The type of the return value (Ballerina record array).
# + return - Filtered dataset containing records that match the comparison or an `etl:Error`.
public function filterDataByRelativeExp(record {}[] dataset, string fieldName, Operation operation, float value, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlFiltering"
} external;
