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

import ballerinax/openai.chat;

function standardizeDataFunc(record {}[] dataset, string fieldName, string[] standardValues, ModelId modelId) returns json|Error {
    string prompt = string ` Identify and replace any approximate matches of the given search values in the dataset with the standard values.  
                                        - Input Dataset: ${dataset.toString()}  
                                        - Field Name: ${fieldName}  
                                        - Search Value: ${standardValues.toString()}  
                                        Return only the standardized dataset as an array of json without any formatting .  
                                        Do not include any additional text, explanations, or variations.
                                        
                                        Example
                                        
                                        - Input Dataset: 
                                        [{"name":"John","city":"Austin","phone":"(555) 555-7873","age":18},
                                         {"name":"Nick","city":"New York","phone":"(555) 555-8823","age":25},
                                         {"name":"Paul","city":"Sydney","phone":"(555) 555-9032","age":35},
                                         {"name":"Jo","city":"Austin","phone":"(555) 555-9120","age":45},
                                         {"name":"Larry","city":"new-york-America","phone":"(555) 555-3022","age":23},
                                         {"name":"James","city":"Portland","phone":"(555) 555-3299","age":23},
                                         {"name":"Smith","city":"newyork-usa","phone":"(555) 555-2313","age":17},
                                         {"name":"Rob","city":"new-yorK","phone":"(555) 555-3124","age":90},
                                         {"name":"Kate","city":"Dallas","phone":"(555) 555-3214","age":40},
                                         {"name":"Tim","city":"Miami","phone":"(555) 555-3123","age":50}]

                                         - Standard Value : "New York"
                                         - Field NAme : "city"

                                         - Output Dataset:
                                         [{"name":"John","city":"Austin","phone":"(555) 555-7873","age":18},
                                          {"name":"Nick","city":"New York","phone":"(555) 555-8823","age":25},
                                          {"name":"Paul","city":"Sydney","phone":"(555) 555-9032","age":35},
                                          {"name":"Jo","city":"Austin","phone":"(555) 555-9120","age":45},
                                          {"name":"Larry","city":"New York","phone":"(555) 555-3022","age":23},
                                          {"name":"James","city":"Portland","phone":"(555) 555-3299","age":23},
                                          {"name":"Smith","city":"New York","phone":"(555) 555-2313","age":17},
                                          {"name":"Rob","city":"New York","phone":"(555) 555-3124","age":90},
                                          {"name":"Kate","city":"Dallas","phone":"(555) 555-3214","age":40},
                                          {"name":"Tim","city":"Miami","phone":"(555) 555-3123","age":50}]`;
    return getResponseFromModel(prompt, modelId);
}

function groupApproximateDuplicatesFunc(record {}[] dataset, ModelId modelId) returns json|Error {
    string prompt = string ` Identify approximate duplicates in the dataset and group them.
                                        - Input Dataset : ${dataset.toString()}  
                                         Respond only with an array of arrays of JSON objects without any formatting where the first array contains all the unique records which does not have any duplicates, and the rest of the arrays contain the duplicate groups.
                                         Do not include any additional text, explanations, or variations.
                                         
                                         Example

                                         - Input Dataset :
                                         [{"customerId":"1","customerName":"John Doe","email":"john.doe@email.com","phone":"1234567890","address":"123 Main St"},
                                          {"customerId":"2","customerName":"Jon Doe","email":"john.doe@email.com","phone":"1234567890","address":"123 Main Street"},
                                          {"customerId":"3","customerName":"Jane Smith","email":"jane.smith@email.com","phone":"0987654321","address":"456 Elm St"},
                                          {"customerId":"4","customerName":"Janet Smith","email":"jane.smith@email.com","phone":"0987654321","address":"456 Elm Street"},
                                          {"customerId":"7","customerName":"Emilly Clark","email":"emily.clark@email.com","phone":"2223334444","address":"101 Pine Street"},
                                          {"customerId":"8","customerName":"John Charles","email":"john.charles@email.com","phone":"3483845456","address":"108 Rose Street"}]

                                        - Output Result :
                                        [[{"customerId":"5","customerName":"Mark Johnson","email":"mark.j@email.com","phone":"1112223333","address":"789 Oak St"},{"customerId":"8","customerName":"John Charles","email":"john.charles@email.com","phone":"3483845456","address":"108 Rose Street"}],
                                         [{"customerId":"1","customerName":"John Doe","email":"john.doe@email.com","phone":"1234567890","address":"123 Main St"},{"customerId":"2","customerName":"Jon Doe","email":"john.doe@email.com","phone":"1234567890","address":"123 Main Street"}],
                                         [{"customerId":"3","customerName":"Jane Smith","email":"jane.smith@email.com","phone":"0987654321","address":"456 Elm St"},{"customerId":"4","customerName":"Janet Smith","email":"jane.smith@email.com","phone":"0987654321","address":"456 Elm Street"}]]`;
    return getResponseFromModel(prompt, modelId);
}

function extractFromUnstructuredDataFunc(string dataset, map<string> returnTypeSchema, ModelId modelId) returns json|Error {
    string prompt = string ` Extract relevant details from the given text and map them to the specified fields. 
                                        - Input Data : ${dataset.toString()} 
                                        - Return Type Schema(Contains field names as keys and their corresponding types as values.): ${returnTypeSchema.toString()}
                                        - Feilds to extract: ${returnTypeSchema.keys().toString()}
                                        Respond with a JSON object without any formatting.
                                        Do not include field names or any additional text, explanations, or variations.

                                        Example

                                        - Input Data :
                                        "The smartphone has an impressive camera and smooth performance, making it great for photography and gaming.
                                        However, the battery drains quickly, and the charging speed could be improved.
                                        The UI is intuitive, but some features feel outdated and need a refresh."

                                        - Return type Schema : {
                                            "goodPoints": "string[]",
                                            "badPoints": "string[]",
                                            "improvements": "string[]"
                                        }

                                        - Expected Output :
                                        {
                                            "goodPoints":["impressive camera","smooth performance","great for photography","great for gaming","UI is intuitive"],
                                            "badPoints":["battery drains quickly","some features feel outdated"],
                                            "improvements":["charging speed could be improved","features need a refresh"]
                                        } `;
    return getResponseFromModel(prompt, modelId);
}

function maskSensitiveDataFunc(record {}[] dataset, string:Char maskingCharacter, ModelId modelId) returns json|Error {
    string prompt = string ` Personally Identifiable Information (PII) includes any data that can be used to identify an individual, either on its own or when combined with other information. Examples of PII include:
                                            -Names: Full name, maiden name, alias
                                            -Addresses: Street, email
                                            -Phone numbers: Mobile, personal, business
                                            -Identifiers: SSN, passport number, driver's license
                                            -Biometric data: Fingerprints, retina scan, voice signature
                                            -Asset information: IP address, MAC address
                                            -Personal features: Photographs, x-rays
                                            -Information about owned property: Vehicle registration number
                                            -Other information: Date of birth, place of birth, race, religion, employment, medical, education, financial details
                                        Under GDPR, additional personal data includes online identifiers like IP addresses, cookie IDs, and de-identified data that can be re-identified.
                                        Non-PII includes information that can't identify an individual, such as anonymized data or a company registration number.
                                        Note: All personal data can be PII, but not all PII is personal data under certain legal frameworks like GDPR.
                    
                                        Identify the fields with Personally Identifiable Information (PII) in the following dataset and mask them with the character ${maskingCharacter} with each character replaced:
                                        - Dataset: ${dataset.toString()}
                                        Return only the masked dataset as an array of json without any formatting .  
                                        Do not include any additional text, explanations, or variations
                                        
                                        Example:
                                        -Input;
                                        [{ "id": 1, "name": "John Doe", "email": "john@example.com" },
                                        { "id": 2, "name": "Jane Smith", "email": "jane@example.com" },
                                        { "id": 3, "name": "Alice", "email": "alice@example.com" }]
                                        -Output:
                                        [{ "id": 1, "name": "XXXX XXX", "email": XXXXXXXXXXXXXXXX" },
                                        { "id": 2, "name": "XXXX XXXXX", "email": XXXXXXXXXXXXXXXX" },
                                        { "id": 3, "name": "XXXXX", "email": XXXXXXXXXXXXXXXXX" }]`;
    return getResponseFromModel(prompt, modelId);
}

function categorizeSemanticFunc(record {}[] dataset, string fieldName, string[] categories, ModelId modelId) returns json|Error {
    string prompt = string `Classify the given dataset into one of the specified categories based on the provided field name.  
                                            - Input Dataset: ${dataset.toString()}  
                                            - Categories: ${categories.toString()}  
                                            - Field: ${fieldName}  
                                            If a record does not belong to any category, ignore them.  
                                            Respond only with an array of arrays of JSON objects without any formatting.  
                                            Do not include any additional text, explanations, or variations. 

                                            Example

                                            - Input Dataset :
                                            [{"order_id":"1","customer_name":"John Doe","comments":"The product quality is excellent and I am very happy!"},
                                            {"order_id":"2","customer_name":"Jane Smith","comments":"It is good. But the delivery was slow."},
                                            {"order_id":"3","customer_name":"Mike Johnson","comments":"Terrible experience. I will never order again."},
                                            {"order_id":"4","customer_name":"Anna Lee","comments":"The customer service was great. But the product was damaged."},
                                            {"order_id":"5","customer_name":"David Brown","comments":"Simply the best! I highly recommend."},
                                            {"order_id":"6","customer_name":"Emily Clark","comments":":);"},
                                            {"order_id":"7","customer_name":"Mark White","comments":"Worst experience ever. Totally disappointed."},
                                            {"order_id":"8","customer_name":"Sophia Green","comments":"Not bad. But could be improved."}]

                                            - Category Names : ["Excellent", "Normal", "Worst"]

                                            - Output Dataset :
                                            [[{"order_id":"1","customer_name":"John Doe","comments":"The product quality is excellent and I am very happy!"},{"order_id":"5","customer_name":"David Brown","comments":"Simply the best! I highly recommend."}],
                                            [{"order_id":"2","customer_name":"Jane Smith","comments":"It is good. But the delivery was slow."},{"order_id":"4","customer_name":"Anna Lee","comments":"The customer service was great. But the product was damaged."},{"order_id":"8","customer_name":"Sophia Green","comments":"Not bad. But could be improved."}],
                                            [{"order_id":"3","customer_name":"Mike Johnson","comments":"Terrible experience. I will never order again."},{"order_id":"7","customer_name":"Mark White","comments":"Worst experience ever. Totally disappointed."}],`;
    return getResponseFromModel(prompt, modelId);
}

function getResponseFromModel(string prompt, ModelId modelId) returns json|Error {
    chat:CreateChatCompletionRequest request = {
        model: modelId,
        messages: [
            {
                "role": "user",
                "content": prompt
            }
        ]
    };
    chat:CreateChatCompletionResponse response = check chatClient->/chat/completions.post(request);
    string content = check response.choices[0].message?.content.ensureType();
    return check content.fromJsonString();
}
