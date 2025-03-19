import ballerina/jballerina.java;

# Extracts unstructured data from a string array and maps it to the specified fields.
# ```ballerina
# string reviews = "The smartphone has an impressive camera and smooth performance, making it great for photography and gaming. However, the battery drains quickly, and the charging speed could be improved. The UI is intuitive, but some features feel outdated and need a refresh.";
# string[] fields = ["goodPoints", "badPoints", "improvements"];
# record {string[] goodPoints; string[] badPoints; string[] improvments} extractedDetails = check etl:extractFromUnstructuredData(reviews, fields);
# ```
#
# + dataset - Array of unstructured string data (e.g., reviews or comments).
# + fieldNames - Array of field names to map the extracted details.
# + modelName - Name of the Open AI model
# + returnType - The type of the return value (Ballerina record).
# + return - A record with extracted details mapped to the specified field names or an `etl:Error`.
public function extractFromUnstructuredData(string dataset, string[] fieldNames, string modelName = "gpt-4o", typedesc<record {}> returnType = <>) returns returnType|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlExtraction"
} external;
