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

type OpenAiChatCompletionRequestUserMessage record {
    string content;
    "user" role;
    string name?;
};

type OpenAiCreateChatCompletionRequest record {
    OpenAiChatCompletionRequestUserMessage[1] messages;
    Model model;
    boolean? store = false;
    decimal? frequency_penalty = 0;
    boolean? logprobs = false;
    int? n = 1;
    decimal? presence_penalty = 0;
    "auto"|"default"? service_tier = "auto";
    boolean? 'stream = false;
    decimal? temperature = 1;
    decimal? top_p = 1;
};

type OpenAiChatCompletionResponseMessage record {
    string? content;
};

type OpenAiCreateChatCompletionResponse_choices record {
    OpenAiChatCompletionResponseMessage message;
};

type OpenAiCreateChatCompletionResponse record {
    OpenAiCreateChatCompletionResponse_choices[] choices;
};
