import ballerina/jballerina.java;
import ballerina/lang.regexp;

# Categorizes a dataset based on a numeric field and specified ranges.
# ```ballerina
# record {}[] dataset = [{"value": 10.5}, {"value": 25.0}, {"value": 5.3}];
# string fieldName = "value";
# float[][] rangeArray = [[0.0, 10.0], [10.0, 20.0]];
# record {}[][] categorized = check etl:categorizeNumeric(dataset, fieldName, rangeArray);
# ```
#
# + dataset - Array of records containing numeric values.
# + fieldName - Name of the numeric field to categorize.
# + rangeArray - Array of float ranges specifying category boundaries.
# + returnType - The type of the return value (Ballerina record array).
# + return - A nested array of categorized records or an error if categorization fails.
public function categorizeNumeric(record {}[] dataset, string fieldName, float[][] rangeArray, typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCategorization"
} external;

# Categorizes a dataset based on a string field using a set of regular expressions.
# ```ballerina
# import ballerina/regexp;
# record {}[] dataset = [
#     { "name": "Alice", "city": "New York" },
#     { "name": "Bob", "city": "Colombo" },
#     { "name": "John", "city": "Boston" },
#     { "name": "Charlie", "city": "Los Angeles" }
# ];
# string fieldName = "name";
# regexp:RegExp[] regexArray = [re `A.*$`, re `^B.*$`, re `^C.*$`];
# record {}[][] categorized = check etl:categorizeRegex(dataset, fieldName, regexArray);
# ```
#
# + dataset - Array of records containing string values.
# + fieldName - Name of the string field to categorize.
# + regexArray - Array of regular expressions for matching categories.
# + returnType - The type of the return value (Ballerina record array).
# + return - A nested array of categorized records or an error if categorization fails.
public function categorizeRegex(record {}[] dataset, string fieldName, regexp:RegExp[] regexArray, typedesc<record {}[]> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlCategorization"
} external;
