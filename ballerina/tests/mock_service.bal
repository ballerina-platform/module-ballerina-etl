import ballerina/http;
import ballerinax/openai.chat;

service on new http:Listener(8080) {
    resource function post chat/completions(chat:CreateChatCompletionRequest payload)
            returns json|error {

        chat:ChatCompletionRequestMessage message = payload.messages[0];
        anydata content = message["content"];
        string contentStr = content.toString();
        return {
            'object: "chat.completion",
            created: 0,
            model: "",
            id: "",
            choices: [
                {
                    finish_reason: "stop",
                    index: 0,
                    logprobs: (),
                    message: {
                        role: "assistant",
                        content: getTheMockServiceResult(contentStr),
                        refusal: ()
                    }
                }
            ]
        };
    }
}
