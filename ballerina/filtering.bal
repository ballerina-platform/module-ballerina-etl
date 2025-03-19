import ballerina/jballerina.java;
import ballerina/lang.regexp;

# Splits a dataset into two parts based on a given ratio.
# ```ballerina
# type Customer record {
#     int id;
#     string name;
# };
# Customer[] dataset = [
#     { "id": 1, "name": "Alice" },
#     { "id": 2, "name": "Bob" },
#     { "id": 3, "name": "Charlie" },
#     { "id": 4, "name": "David" }
# ];
# Customer[][] filteredDataset = check etl:filterDataByRatio(dataset, 0.75);
# ```
#
# + dataset - Array of records to be split.
# + ratio - The ratio for splitting the dataset (e.g., `0.75` means 75% in the first set).
# + returnType - The type of the return value (Ballerina record array).
# + return - An array containing two arrays: one with the first subset and the other with the second subset or an `etl:Error`.
public function filterDataByRatio(record {}[] dataset, float ratio, typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlFiltering"
} external;

# Filters a dataset into two subsets based on a regex pattern match.
# ```ballerina
# type Customer record {
#     int id;
#     string city;
# };
# Customer[] dataset = [
#     { "id": 1, "city": "New York" },
#     { "id": 2, "city": "Los Angeles" },
#     { "id": 3, "city": "San Francisco" }
# ];
# string fieldName = "city";
# regexp:RegExp regexPattern = re `^New.*$`;
# Customer[][] filteredDataset = check etl:filterDataByRegex(dataset, "city", regexPattern);
# ```
#
# + dataset - Array of records to be filtered.
# + fieldName - Name of the field to apply the regex filter.
# + regexPattern - Regular expression to match values in the field.
# + returnType - The type of the return value (Ballerina record array).
# + return - An array containing two arrays: one with the matching subset and the other with the non-matching subset or an `etl:Error`.
public function filterDataByRegex(record {}[] dataset, string fieldName, regexp:RegExp regexPattern, typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlFiltering"
} external;

# Filters a dataset based on a relative numeric comparison expression.
#
# ```ballerina
# type Customer record {
#     int id;
#     string name;
#     int age;
# };
# Customer[] dataset = [
#     { "id": 1, "name": "Alice", "age": 25 },
#     { "id": 2, "name": "Bob", "age": 30 },
#     { "id": 3, "name": "Charlie", "age": 22 },
#     { "id": 4, "name": "David", "age": 28 }
# ];
# Customer[][] filteredDataset = check etl:filterDataByRelativeExp(dataset, "age", etl:GREATER_THAN, 25);
# ```
#
# + dataset - Array of records containing numeric fields for comparison.
# + fieldName - Name of the field to evaluate.
# + operation - Comparison operation to apply as `etl:Operation`.
# + value - Numeric value to compare against.
# + returnType - The type of the return value (Ballerina record array).
# + return - An array containing two arrays: one with the matching subset and the other with the non-matching subset or an `etl:Error`.
public function filterDataByRelativeExp(record {}[] dataset, string fieldName, Operation operation, float value, typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlFiltering"
} external;
