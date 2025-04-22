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

import ballerina/http;

enum Model {
    GPT_4_TURBO = "gpt-4-turbo",
    GPT_4O = "gpt-4o",
    GPT_4O_MINI = "gpt-4o-mini"
}

isolated client class OpenAIModel {
    final http:Client clientEp;
    final Model model;

    isolated function init(string openAIToken, Model model, int timeout, string serviceUrl) returns error? {
        http:ClientConfiguration httpClientConfig = {auth: {token: openAIToken}, timeout:check timeout.ensureType(decimal)};
        http:Client httpEp = check new (serviceUrl, httpClientConfig);
        self.clientEp = httpEp;
        self.model = model;
        return;
    }

    isolated function chat(OpenAICreateChatCompletionRequest chatBody)
            returns OpenAICreateChatCompletionResponse|error {
        return self.clientEp->/chat/completions.post(chatBody);
    }
}
