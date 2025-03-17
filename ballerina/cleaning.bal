import ballerina/jballerina.java;
import ballerina/lang.regexp;

# Sorts a dataset based on a specific field in ascending or descending order.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "age": 25 },
#     { "name": "Bob", "age": 30 },
#     { "name": "Charlie", "age": 22 }
# ];
# string fieldName = "age";
# boolean isAscending = true;
# record {}[] sortedData = check etl:sort(dataset, fieldName, isAscending);
# ```
#
# + dataset - Array of records to be sorted.
# + fieldName - The field by which sorting is performed.
# + isAscending - Boolean flag to determine sorting order (default: ascending).
# + returnType - The type of the return value (Ballerina record).
# + return - A sorted dataset based on the specified field.
public function sortData(record {}[] dataset, string fieldName, boolean isAscending, typedesc<map<anydata>> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Removes a specified field from each record in the dataset.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York", "age": 30 },
#     { "name": "Bob", "city": "Los Angeles", "age": 25 },
#     { "name": "Charlie", "city": "Chicago", "age": 35 }
# ];
# string fieldName = "age";
# record {}[] updatedData = check etl:removeField(dataset, fieldName);
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
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": null },
#     { "name": "Charlie", "city": "" }
# ];
# record {}[] filteredData = check etl:removeNull(dataset);
# ```
#
# + dataset - Array of records containing potential null or empty fields.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset with records containing null or empty string values removed.
public function removeNull(record {}[] dataset, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Removes duplicate records from the dataset based on their exact content.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "Los Angeles" },
#     { "name": "Alice", "city": "New York" }
# ];
# record {}[] uniqueData = check etl:removeDuplicates(dataset);
# ```
#
# + dataset - Array of records that may contain duplicates.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset with duplicates removed.
public function removeDuplicates(record {}[] dataset, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Replaces text in a specific field of a dataset using regular expressions.
# ```ballerina
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "Los Angeles" },
#     { "name": "Charlie", "city": "Chicago" }
# ];
# string fieldName = "city";
# regexp:RegExp searchValue = re `New York`;
# string replaceValue = "San Francisco";
# record {}[] updatedData = check etl:replaceText(dataset, fieldName, searchValue, replaceValue);
# ```
#
# + dataset - Array of records where text in a specified field will be replaced.
# + fieldName - The name of the field where text replacement will occur.
# + searchValue - A regular expression to match text that will be replaced.
# + replaceValue - The value that will replace the matched text.
# + returnType - The type of the return value (Ballerina record).
# + return - A new dataset with the replaced text in the specified field.
public function replaceText(record {}[] dataset, string fieldName, regexp:RegExp searchValue, string replaceValue, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;

# Cleans up whitespace in all fields of a dataset.
# ```ballerina
# record {}[] dataset = [
#     { "name": "  Alice   ", "city": "New   York  " },
#     { "name": "   Bob", "city": "Los  Angeles  " }
# ];
# record {}[] cleanedData = check etl:handleWhiteSpaces(dataset);
# ```
#
# + dataset - Array of records with possible extra spaces.
# + returnType - The type of the return value (Ballerina record).
# + return - A dataset where multiple spaces are replaced with a single space, and values are trimmed.
public function handleWhiteSpaces(record {}[] dataset, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCleaning"
} external;
