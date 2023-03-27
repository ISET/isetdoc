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

% Define the API endpoint Davinci
%api_endpoint = "https://api.openai.com/v1/engines/davinci/completions";

% Use more modern endpoint
api_endpoint = "https://api.openai.com/v1/completions";

% Define the API key from https://beta.openai.com/account/api-keys
api_key = "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";

% Define the parameters for the API request
prompt = "Who is Brian Wandell?";
parameters = struct('prompt',prompt, 'max_tokens',1000);
% Define the headers for the API request
headers = matlab.net.http.HeaderField('Content-Type', 'application/json');
headers(2) = matlab.net.http.HeaderField('Authorization', ['Bearer ' + api_key]);

%messageData = '"model": "gpt-3.5-turbo","messages": [{"role": "user", "content": "Say this is a test!"}], "temperature": "0.7"';
messageData = [];


%messageData(1).Name = 'model';
%messageData(1).Value = 'gpt-3.5-turbo';

messageData = '"model"="gpt-3.5-turbo"';

requestData = matlab.net.http.MessageBody(messageData);

% Define the request message
%request = matlab.net.http.RequestMessage('post',headers,parameters);
request = matlab.net.http.RequestMessage('post',headers,requestData);
% Send the request and store the response
response = send(request, URI(api_endpoint));
% Extract the response text
response_text = response.Body.Data;
response_text = response_text.choices(1).text;
disp(response_text);