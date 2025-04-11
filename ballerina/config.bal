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

type ModelConfig record{|
    chat:ConnectionConfig connectionConfig; 
    string? serviceUrl?;
    string model;
|};

configurable ModelConfig? modelConfig = ();

chat:Client? chatClient = ();
string? model = ();
function init() returns error?{
    ModelConfig? modelConfigVar = modelConfig;
    if modelConfigVar is ModelConfig {
        string? serviceUrl = modelConfigVar?.serviceUrl;
        chatClient = serviceUrl is () ? check new chat:Client(modelConfigVar?.connectionConfig) : check new chat:Client(modelConfigVar?.connectionConfig, serviceUrl);
        model = modelConfigVar?.model;
        return;
    }
}

function getChatClient() returns chat:Client {
    final chat:Client? clientVar = chatClient;
    if clientVar is (){
        panic error("Chat client is not initialized");
    }
    return clientVar;
}

function getModel() returns string {
    final string? modelVar = model;
    if modelVar is (){
        panic error("Model is not initialized");
    }
    return modelVar;
}

