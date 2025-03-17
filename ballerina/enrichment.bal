import ballerina/jballerina.java;

# Merges two datasets based on a common primary key, updating records from the first dataset with matching records from the second.
# ```ballerina
# record {}[] dataset1 = [{id: 1, name: "Alice"}, {id: 2, name: "Bob"}];
# record {}[] dataset2 = [{id: 1, age: 25}, {id: 2, age: 30}];
# string primaryKey = "id";
# record {}[] mergedData = check etl:joinData(dataset1, dataset2, primaryKey);
# ```
#
# + dataset1 - First dataset containing base records.
# + dataset2 - Second dataset with additional data to be merged.
# + primaryKey - The field used to match records between the datasets.
# + returnType - The type of the return value (Ballerina record).
# + return - A merged dataset with updated records or an error if merging fails.
public function joinData(record {}[] dataset1, record {}[] dataset2, string primaryKey, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlEnrichment"
} external;

# Merges multiple datasets into a single dataset by flattening a nested array of records.
# ```ballerina
# record {}[][] dataSets = [
#     [{id: 1, name: "Alice"}, {id: 2, name: "Bob"}],
#     [{id: 3, name: "Charlie"}, {id: 4, name: "David"}]
# ];
# record {}[] mergedData = check etl:mergeData(dataSets);
# ```
#
# + datasets - An array of datasets, where each dataset is an array of records.
# + returnType - The type of the return value (Ballerina record).
# + return - A single merged dataset containing all records or an error if merging fails.
public function mergeData(record {}[][] datasets, typedesc<record {}> returnType = <>) returns returnType[]|Error = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.EtlEnrichment"
} external;

