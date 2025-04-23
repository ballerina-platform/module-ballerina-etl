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

import ballerina/jballerina.java;

type ModelConfig record {|
    string openAIToken;
    int? timeout?;
    string? serviceUrl?;
    Model model;
|};

configurable ModelConfig? modelConfig = ();

OpenAIModel? openAIModel = ();

function init() returns error? {
    ModelConfig? modelConfigVar = modelConfig;
    if modelConfigVar is ModelConfig {
        string serviceUrl = modelConfigVar?.serviceUrl ?: "https://api.openai.com/v1";
        int timeout = modelConfigVar?.timeout ?: 60;
        openAIModel = check new OpenAIModel(modelConfigVar?.openAIToken, modelConfigVar?.model, timeout, serviceUrl);
    }
    setModule();
}

function getModel() returns OpenAIModel {
    final OpenAIModel? openAIModelVar = openAIModel;
    if openAIModelVar is () {
        panic error("OpenAI Model is not initialized");
    }
    return openAIModelVar;
}

function setModule() = @java:Method {
    'class: "io.ballerina.stdlib.etl.nativeimpl.ModuleUtils"
} external;
