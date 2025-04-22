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

type ClientHttp1Settings record {|
    http:KeepAlive keepAlive = http:KEEPALIVE_AUTO;
    http:Chunking chunking = http:CHUNKING_AUTO;
    ProxyConfig proxy?;
|};

type ProxyConfig record {|
    string host = "";
    int port = 0;
    string userName = "";
    @display {label: "", kind: "password"}
    string password = "";
|};

type OpenAIConnectionConfig record {|
    http:BearerTokenConfig auth;
    http:HttpVersion httpVersion = http:HTTP_2_0;
    ClientHttp1Settings http1Settings?;
    http:ClientHttp2Settings http2Settings?;
    decimal timeout = 60;
    string forwarded = "disable";
    http:PoolConfiguration poolConfig?;
    http:CacheConfig cache?;
    http:Compression compression = http:COMPRESSION_AUTO;
    http:CircuitBreakerConfig circuitBreaker?;
    http:RetryConfig retryConfig?;
    http:ResponseLimitConfigs responseLimits?;
    http:ClientSecureSocket secureSocket?;
    http:ProxyConfig proxy?;
    boolean validation = true;
|};

type OpenAIChatCompletionRequestUserMessage record {
    string content;
    "user" role;
    string name?;
};

type OpenAICreateChatCompletionRequest record {
    OpenAIChatCompletionRequestUserMessage[1] messages;
    string model;
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

type OpenAIChatCompletionResponseMessage record {
    string? content;
};

type OpenAICreateChatCompletionResponse_choices record {
    OpenAIChatCompletionResponseMessage message;
};

type OpenAICreateChatCompletionResponse record {
    OpenAICreateChatCompletionResponse_choices[] choices;
};
