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

type ModelConfig record {|
    OpenAIConnectionConfig connectionConfig;
    string? serviceUrl?;
    string model;
|};

configurable ModelConfig? modelConfig = ();

OpenAIClient? chatClient = ();
string? model = ();

function init() returns error? {
    ModelConfig? modelConfigVar = modelConfig;
    if modelConfigVar is ModelConfig {
        string? serviceUrl = modelConfigVar?.serviceUrl;
        chatClient = serviceUrl is () ? check new OpenAIClient(modelConfigVar?.connectionConfig) : check new OpenAIClient(modelConfigVar?.connectionConfig, serviceUrl);
        model = modelConfigVar?.model;
        return;
    }
}

function getChatClient() returns OpenAIClient {
    final OpenAIClient? clientVar = chatClient;
    if clientVar is () {
        panic error("Chat client is not initialized");
    }
    return clientVar;
}

function getModel() returns string {
    final string? modelVar = model;
    if modelVar is () {
        panic error("Model is not initialized");
    }
    return modelVar;
}

