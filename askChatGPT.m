import matlab.net.*
import matlab.net.http.*

%{
    open ai example:
curl https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
     "model": "gpt-3.5-turbo",
     "messages": [{"role": "user", "content": "Say this is a test!"}],
     "temperature": 0.7
   }'
%}

% Use  modern endpoint
api_endpoint = "https://api.openai.com/v1/chat/completions";

% Define the API key from https://beta.openai.com/account/api-keys
api_key = "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";

% Define the parameters for the API request
parameters = struct('prompt',prompt, 'max_tokens',4000);
% Define the headers for the API request
headers = matlab.net.http.HeaderField('Content-Type', 'application/json');
headers(2) = matlab.net.http.HeaderField('Authorization', ['Bearer ' + api_key]);

modelName = 'gpt-3.5-turbo';

% Probably need to read the file into a character vector or string

sourceFile = 'askChatGPT.m';
sourceText = fileread(which(sourceFile));

chatPrompt = 'Please document https://github.com/ISET/iset3d/blob/main/%40recipe/recipe.m\n';
chatPrompt = 'What is a cat?';
%chatPrompt = ['{' jsonencode(chatPrompt) '}'];
chatPrompt = jsonencode(chatPrompt);

%messageData = sprintf('{"model":"%s","messages": [{"role": "user", "content": "%s"}]}', ...
%    modelName, chatPrompt);
messageData = sprintf('{"model":"%s","messages": ["role": "user", "content": "%s"]}', ...
    modelName, chatPrompt);

jsonData = messageData; % jsonencode(messageData);
requestData = matlab.net.http.MessageBody(jsonData);
%requestData.Payload = messageData;

% Define the request message
%request = matlab.net.http.RequestMessage('post',headers,parameters);
request = matlab.net.http.RequestMessage('post',headers,requestData);
% Send the request and store the response
response = send(request, URI(api_endpoint));
% Extract the response text
response_text = response.Body.Data;
try
    disp(response_text.choices.message);
catch
    disp(response_text.error);
end


%messageData = sprintf('{"model":"%s","messages": [{"role": "user", "content": "%s"}]}', ...
%    modelName, chatPrompt);

%requestData = matlab.net.http.MessageBody(messageData);
%requestData.Payload = messageData;

% Define the request message
%request = matlab.net.http.RequestMessage('post',headers,parameters);
%request = matlab.net.http.RequestMessage('post',headers,requestData);
% Send the request and store the response
%response = send(request, URI(api_endpoint));
% Extract the response text
%response_text = response.Body.Data;
%disp(response_text.choices.message);