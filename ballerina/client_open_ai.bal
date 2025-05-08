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

isolated client class OpenAiClient {
    final http:Client clientEp;

    isolated function init(string openAIToken, decimal timeout) returns error? {
        http:ClientConfiguration httpClientConfig = {auth: {token: openAIToken}, timeout};
        http:Client httpEp = check new ("https://api.openai.com/v1", httpClientConfig);
        self.clientEp = httpEp;
        return;
    }

    isolated function chat(OpenAiCreateChatCompletionRequest chatBody)
            returns OpenAiCreateChatCompletionResponse|error {
        return self.clientEp->/chat/completions.post(chatBody);
    }
}
