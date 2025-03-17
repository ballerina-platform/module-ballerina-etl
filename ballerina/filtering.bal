import ballerina/jballerina.java;
import ballerina/lang.regexp;

# Splits a dataset into two parts based on a given ratio.
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "Alice" },
#     { "id": 2, "name": "Bob" },
#     { "id": 3, "name": "Charlie" },
#     { "id": 4, "name": "David" }
# ];
# float ratio = 0.75;
# [record {}[], record {}[]] [part1, part2] = check etl:filterDataByRatio(dataset, ratio);
# ```
#
# + dataset - Array of records to be split.
# + ratio - The ratio for splitting the dataset (e.g., `0.75` means 75% in the first set).
# + returnType - The type of the return value (Ballerina record array).
# + return - A tuple containing two subsets of the dataset.
public function filterDataByRatio(record {}[] dataset, float ratio, typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlFiltering"
} external;

# Filters a dataset into two subsets based on a regex pattern match.
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "city": "New York" },
#     { "id": 2, "city": "Los Angeles" },
#     { "id": 3, "city": "Newark" },
#     { "id": 4, "city": "San Francisco" }
# ];
# string fieldName = "city";
# regexp:RegExp regexPattern = re `^New.*$`;
# [record {}[], record {}[]] [matched, nonMatched] = check etl:filterDataByRegex(dataset, fieldName, regexPattern);
# ```
#
# + dataset - Array of records to be filtered.
# + fieldName - Name of the field to apply the regex filter.
# + regexPattern - Regular expression to match values in the field.
# + returnType - The type of the return value (Ballerina record array).
# + return - A tuple with two subsets: matched and non-matched records.
public function filterDataByRegex(record {}[] dataset, string fieldName, regexp:RegExp regexPattern, typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlFiltering"
} external;

# Filters a dataset based on a relative numeric comparison expression.
#
# ```ballerina
# record {}[] dataset = [
#     { "id": 1, "name": "Alice", "age": 25 },
#     { "id": 2, "name": "Bob", "age": 30 },
#     { "id": 3, "name": "Charlie", "age": 22 },
#     { "id": 4, "name": "David", "age": 28 }
# ];
# string fieldName = "age";
# string operation = ">";
# float value = 25;
# [record {}[], record {}[]] [olderThan25, youngerOrEqual25] = check etl:filterDataByRelativeExp(dataset, fieldName, operation, value);
# ```
#
# + dataset - Array of records containing numeric fields for comparison.
# + fieldName - Name of the field to evaluate.
# + operation - Comparison operator (`>`, `<`, `>=`, `<=`, `==`, `!=`). 
# + value - Numeric value to compare against.
# + returnType - The type of the return value (Ballerina record array).
# + return - A tuple with two subsets: one that matches the condition and one that does not.
public function filterDataByRelativeExp(record {}[] dataset, string fieldName, Operation operation, float value, typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlFiltering"
} external;
