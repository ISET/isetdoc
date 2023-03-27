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
parameters = struct('prompt',prompt, 'max_tokens',1000);
% Define the headers for the API request
headers = matlab.net.http.HeaderField('Content-Type', 'application/json');
headers(2) = matlab.net.http.HeaderField('Authorization', ['Bearer ' + api_key]);

modelName = 'gpt-3.5-turbo';

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
parameters = struct('prompt',prompt, 'max_tokens',1000);
% Define the headers for the API request
headers = matlab.net.http.HeaderField('Content-Type', 'application/json');
headers(2) = matlab.net.http.HeaderField('Authorization', ['Bearer ' + api_key]);

modelName = 'gpt-3.5-turbo';

% Probably need to read the file into a character vector or string

sourceFile = 'askChatGPT.m';
sourceText = fileread(which(sourceFile));
chatPrompt = sprintf('Please document \n %s', sourceText);

messageData = sprintf('{"model":"%s","messages": [{"role": "user", "content": "%s"}]}', ...
    modelName, chatPrompt);

requestData = matlab.net.http.MessageBody(messageData);
%requestData.Payload = messageData;

% Define the request message
%request = matlab.net.http.RequestMessage('post',headers,parameters);
request = matlab.net.http.RequestMessage('post',headers,requestData);
% Send the request and store the response
response = send(request, URI(api_endpoint));
% Extract the response text
response_text = response.Body.Data;
disp(response_text.choices.message);

% Not clear the best way to get a source file into a Matlab string

chatPrompt = sprintf('Please document %s', sourceCode);

messageData = sprintf('{"model":"%s","messages": [{"role": "user", "content": "%s"}]}', ...
    modelName, chatPrompt);

requestData = matlab.net.http.MessageBody(messageData);
requestData.Payload = messageData;

% Define the request message
%request = matlab.net.http.RequestMessage('post',headers,parameters);
request = matlab.net.http.RequestMessage('post',headers,requestData);
% Send the request and store the response
response = send(request, URI(api_endpoint));
% Extract the response text
response_text = response.Body.Data;
disp(response_text.choices.message);