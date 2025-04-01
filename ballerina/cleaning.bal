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

# Identifies approximate duplicates in a dataset and groups them, returning unique records separately.
# ```ballerina
# Customer[] dataset = [
#     { name: "Alice", city: "New York" },
#     { name: "Alice", city: "new york" },
#     { name: "Bob", city: "Boston" },
#     { name: "Charlie", city: "Los Angeles" },
#     { name: "Charlie", city: "los angeles - usa" },
#     { name: "John", city: "Chicago" }
# ];
# Customer[][] result = check etl:groupApproximateDuplicates(dataset);
#
# => [[{ name: "Bob", city: "Boston" },{ name: "John", city: "Chicago" }],
#     [{ name: "Alice", city: "New York" },{ name: "Alice", city: "new york" }],
#     [{ name: "Charlie", city: "Los Angeles" },{ name: "Charlie", city: "los angeles - usa" }]]
# ```
#
# + dataset - Array of records that may contain approximate duplicates.
# + modelId - Name of the Open AI model.
# + returnType - The type of the return value (Ballerina record).
# + return - A nested array of records where the first array contains all unique records that do not have any duplicates,
# and the remaining arrays contain duplicate groups or an `etl:Error`.
public function groupApproximateDuplicates(record {}[] dataset, ModelId modelId = GPT_4o, typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Cleans up extra whitespace in all string fields of a dataset.
# ```ballerina
# Customer[] dataset = [
#     { name: "  Alice  ", city: "  New   York  " },
#     { name: "  Bob  ", city: "  Los Angeles  " },
#     { name: "  Charlie  ", city: "  Chicago  " }
# ];
# Customer[] cleanedData = check etl:handleWhiteSpaces(dataset);
#
# => [{ name: "Alice", city: "New York" },
#     { name: "Bob", city: "Los Angeles" },
#     { name: "Charlie", city: "Chicago" }]
# ```
#
# + dataset - Array of records with possible extra spaces.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset where multiple spaces are replaced with a single space, and values are trimmed or an `etl:Error`.
public function handleWhiteSpaces(record {}[] dataset, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Removes duplicate records from the dataset based on their exact content.
# ```ballerina
# Customer[] dataset = [
#     { name: "Alice", city: "New York" },
#     { name: "Alice", city: "New York" },
#     { name: "Bob", city: "Los Angeles" },
#     { name: "Charlie", city: "Chicago" },
#     { name: "Charlie", city: "Chicago" }
# ];
# Customer[] uniqueData = check etl:removeDuplicates(dataset);
#
# => [{ name: "Alice", city: "New York" },
#     { name: "Bob", city: "Los Angeles" },
#     { name: "Charlie", city: "Chicago" }]
# ```
#
# + dataset - Array of records that may contain duplicates.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset with duplicates removed or an `etl:Error`.
public function removeDuplicates(record {}[] dataset, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Removes a specified field from each record in the dataset.
# ```ballerina
# Customer[] dataset = [
#     { name: "Alice", city: "New York", age: 25 },
#     { name: "Bob", city: "Los Angeles", age: 30 },
#     { name: "Charlie", city: "Chicago", age: 35 }
# ];
# NewCustomer[] updatedData = check etl:removeField(dataset, "age");
#
# => [{ name: "Alice", city: "New York" },
#     { name: "Bob", city: "Los Angeles" },
#     { name: "Charlie", city: "Chicago" }]
# ```
#
# + dataset - Array of records with fields to be removed.
# + fieldName - The name of the field to remove from each record.
# + returnType - The type of the return value (Ballerina record).
# + return - A new dataset with the specified field removed from each record or an `etl:Error`.
public function removeField(record {}[] dataset, string fieldName, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Removes records that contain nil, empty parentheses, or empty string values in any field.
# ```ballerina
# Customer[] dataset = [
#     { name: "Alice", city: "New York" },
#     { name: "Bob", city: null },
#     { name: "", city: "Los Angeles" },
#     { name: "Charlie", city: "Boston" },
#     { name: "David", city: () }
# ];
# NewCustomer[] filteredData = check etl:removeNull(dataset);
#
# => [{ name: "Alice", city: "New York" },
#     { name: "Charlie", city: "Boston" }]
# ```
#
# + dataset - Array of records containing potential null or empty fields.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset with records containing nil or empty string values removed or an `etl:Error`.
public function removeEmptyValues(record {}[] dataset, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Replaces text in a specific string field of a dataset using regular expressions.
# ```ballerina
# Customer[] dataset = [
#     { name: "Alice", city: "New York" },
#     { name: "Bob", city: "Los Angeles" },
#     { name: "Charlie", city: "Chicago" }
# ];
# Customer[] updatedData = check etl:replaceText(dataset, "city", re `New York`, "San Francisco");
#
# => [{ name: "Alice", city: "San Francisco" },
#     { name: "Bob", city: "Los Angeles" },
#     { name: "Charlie", city: "Chicago" }]
# ```
#
# + dataset - Array of records where text in a specified field will be replaced.
# + fieldName - The name of the field where text replacement will occur.
# + searchValue - A regular expression to match text that will be replaced.
# + replaceValue - The value that will replace the matched text.
# + returnType - The type of the return value (Ballerina record).
# + return - A new dataset with the replaced text in the specified field or an `etl:Error`.
public function replaceText(record {}[] dataset, string fieldName, regexp:RegExp searchValue, string replaceValue, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Sorts a dataset based on a specific field in ascending or descending order.
# ```ballerina
# Customer[] dataset = [
#     { name: "Alice", age: 25 },
#     { name: "Bob", age: 30 },
#     { name: "Charlie", age: 22 }
# ];
# Customer[] sortedData = check etl:sort(dataset, "age");
#
# => [{ name: "Charlie", age: 22 },
#     { name: "Alice", age: 25 },
#     { name: "Bob", age: 30 }]
# ```
#
# + dataset - Array of records to be sorted.
# + fieldName - The field by which sorting is performed.
# + direction - direction in which to sort the data.
# + returnType - The type of the return value (Ballerina record).
# + return - A sorted dataset based on the specified field or an `etl:Error`.
public function sortData(record {}[] dataset, string fieldName, SortDirection direction = ASCENDING, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Standardizes string values in a dataset based on approximate matches.
# ```ballerina
# Customer[] dataset = [
#     { name: "Alice", city: "New York" },
#     { name: "Bob", city: "new york" },
#     { name: "Charlie", city: "los-angeles" },
#     { name: "John", city: "newyork -usa" }    
# ];
# Customer[] standardizedData = check etl:standardizeData(dataset, "city", ["New York", "Los Angeles"]);
#
# => [{ name: "Alice", city: "New York" },
#     { name: "Bob", city: "New York" },
#     { name: "Charlie", city: "Los Angeles" },
#     { name: "John", city: "New York" }]
# ```
#
# + dataset - Array of records containing string values to be standardized.
# + fieldName - The name of the field to standardize.
# + standardValues - An array of standard values to replace approximate matches.
# + modelId - Name of the Open AI model.
# + returnType - The type of the return value (Ballerina record).
# + return - An updated dataset with standardized string values or an error if the operation fails or an `etl:Error`.
public function standardizeData(record {}[] dataset, string fieldName, string[] standardValues, ModelId modelId = GPT_4o, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;
