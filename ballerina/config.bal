import ballerinax/openai.chat;

configurable string openAIKey = "";

final chat:Client chatClient = check new ({
    auth: {
        token: openAIKey
    }
});
