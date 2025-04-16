import ballerina/http;

# Provides settings related to HTTP/1.x protocol.
type ClientHttp1Settings record {|
    # Specifies whether to reuse a connection for multiple requests
    http:KeepAlive keepAlive = http:KEEPALIVE_AUTO;
    # The chunking behaviour of the request
    http:Chunking chunking = http:CHUNKING_AUTO;
    # Proxy server related options
    ProxyConfig proxy?;
|};

# Proxy server configurations to be used with the HTTP client endpoint.
type ProxyConfig record {|
    # Host name of the proxy server
    string host = "";
    # Proxy server port
    int port = 0;
    # Proxy server username
    string userName = "";
    # Proxy server password
    @display {label: "", kind: "password"}
    string password = "";
|};

# Connection configuration for OpenAI.
type OpenAIConnectionConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    ClientHttp1Settings http1Settings?;
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings?;
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache?;
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits?;
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
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
