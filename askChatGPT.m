function [status, result] = askChatGPT(chatPrompt)

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
api_key = getpref('chatGPT','apikey','');

%{
% Example chatPrompts
chatPrompt = 'Please write exhaustive documentation for https://github.com/ISET/iset3d/blob/main/%40recipe/recipeGet.m in Markdown format';
chatPrompt = 'Please write documentation for the Matab script https://github.com/ISET/isetauto/blob/metadata/scripts/s_recipeMatCreate.m';
%chatPrompt = ['{' jsonencode(chatPrompt) '}'];
%}

% Define the parameters for the API request
parameters = struct('prompt',chatPrompt, 'max_tokens',4000);
% Define the headers for the API request
headers = matlab.net.http.HeaderField('Content-Type', 'application/json');
headers(2) = matlab.net.http.HeaderField('Authorization', ['Bearer ' + api_key]);

modelName = 'gpt-3.5-turbo';

% Probably need to read the file into a character vector or string

sourceFile = 'askChatGPT.m';
sourceText = fileread(which(sourceFile));

messageData = sprintf('{"model":"%s","messages": [{"role": "user", "content": "%s"}]}', ...
    modelName, chatPrompt);

jsonData = messageData; % jsonencode(messageData);

requestData = matlab.net.http.MessageBody(jsonData);
requestData.Payload = messageData;

% Define the request message
%request = matlab.net.http.RequestMessage('post',headers,parameters);
request = matlab.net.http.RequestMessage('post',headers,requestData);
% Send the request and store the response
response = send(request, URI(api_endpoint));
% Extract the response text
response_text = response.Body.Data;
try
    result = response_text.choices.message.content;
    status = 0;
catch
    result = response_text.error;
    status = -1;
end

