import ballerina/jballerina.java;
import ballerina/lang.regexp;

# Identifies approximate duplicates in a dataset and groups them, returning unique records separately.
# ```ballerina
# type Customer record {
#     string name;
#     string city;
# };
# Customer[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "New York" },
#     { "name": "Alice", "city": "new york" },
#     { "name": "Charlie", "city": "Los Angeles" }
# ];
# Customer[][] result = check etl:groupApproximateDuplicates(dataset);
# ```
#
# + dataset - Array of records that may contain approximate duplicates.
# + modelName - Name of the Open AI model
# + returnType - The type of the return value (Ballerina record).
# + return - A nested array of records where the first array contains all the unique records which
# does not have any duplicates, and the rest of the arrays contain the duplicate groups or an `etl:Error`.
public function groupApproximateDuplicates(record {}[] dataset, string modelName = "gpt-4o", typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Cleans up whitespace in all fields of a dataset.
# ```ballerina
# type Customer record {
#     string name;
#     string city;
# };
# Customer[] dataset = [
#     { "name": "  Alice   ", "city": "New   York  " },
#     { "name": "   Bob", "city": "Los  Angeles  " }
# ];
# Customer[] cleanedData = check etl:handleWhiteSpaces(dataset);
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
# type Customer record {
#     string name;
#     string city;
# };
# Customer[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "Los Angeles" },
#     { "name": "Alice", "city": "New York" }
# ];
# Customer[] uniqueData = check etl:removeDuplicates(dataset);
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
# type Customer record {
#     string name;
#     string city;
#     int age?;
# };
# Customer[] dataset = [
#     { "name": "Alice", "city": "New York", "age": 30 },
#     { "name": "Bob", "city": "Los Angeles", "age": 25 },
#     { "name": "Charlie", "city": "Chicago", "age": 35 }
# ];
# Customer[] updatedData = check etl:removeField(dataset, "age");
# ```
#
# + dataset - Array of records with fields to be removed.
# + fieldName - The name of the field to remove from each record.
# + returnType - The type of the return value (Ballerina record).
# + return - A new dataset with the specified field removed from each record.
public function removeField(record {}[] dataset, string fieldName, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Removes records that contain null or empty string values in any field.
# ```ballerina
# type Customer record {
#     string name;
#     string? city;
# };
# Customer[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": null },
#     { "name": "Charlie", "city": "" }
# ];
# Customer[] filteredData = check etl:removeNull(dataset);
# ```
#
# + dataset - Array of records containing potential null or empty fields.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset with records containing null or empty string values removed or an `etl:Error`.
public function removeNull(record {}[] dataset, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Replaces text in a specific field of a dataset using regular expressions.
# ```ballerina
# type Customer record {
#     string name;
#     string city;
# };
# Customer[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "Los Angeles" },
#     { "name": "Charlie", "city": "Chicago" }
# ];
# Customer[] updatedData = check etl:replaceText(dataset, "city", re `New York`, "San Francisco");
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
# type Customer record {
#     string name;
#     int age;
# };
# Customer[] dataset = [
#     { "name": "Alice", "age": 25 },
#     { "name": "Bob", "age": 30 },
#     { "name": "Charlie", "age": 22 }
# ];
# Customer[] sortedData = check etl:sort(dataset, "age");
# ```
#
# + dataset - Array of records to be sorted.
# + fieldName - The field by which sorting is performed.
# + isAscending - Boolean flag to determine sorting order.
# + returnType - The type of the return value (Ballerina record).
# + return - A sorted dataset based on the specified field or an `etl:Error`.
public function sortData(record {}[] dataset, string fieldName, boolean isAscending = true, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Standardizes a dataset by replacing approximate matches in a string field with a specified search value.
# ```ballerina
# type Customer record {
#     string name;
#     string city;
# };
# Customer[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "newyork-usa" },
#     { "name": "John", "city": "new york" },
#     { "name": "Charlie", "city": "Los Angeles" }
# ];
# Customer[] standardizedData = check etl:standardizeData(dataset, "city", "New York");
# ```
#
# + dataset - Array of records containing string values to be standardized.
# + fieldName - Name of the string field to check for approximate matches.
# + standardValue - The exact value to replace approximate matches.
# + modelName - Name of the Open AI model
# + returnType - The type of the return value (Ballerina record).
# + return - An updated dataset with standardized string values or an error if the operation fails or an `etl:Error`.
public function standardizeData(record {}[] dataset, string fieldName, string standardValue, string modelName = "gpt-4o", typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;
