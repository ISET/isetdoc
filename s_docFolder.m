% have chatGPT write documentation for an ISET folder
%
% D. Cardinal, Stanford University, 2023

% 
%
% Where to store the documentation
idRootPath = 'c:\iset\isetdoc'; % make into a function

ourRootDocFolder = fullfile(idRootPath,'documenentation');

% set a prefix for our prompt:
%chatPrefix = 'Please write documentation in Markdown format for the Matab source code ';
chatPrefix = 'Please write documentation in Markdown format that explains why this Matab source code is unique ';

% assume ISETAuto for now
whichSourceFolder = 'scripts';
ourFolder = fullfile(iaRootPath, whichSourceFolder);
ourDocFolder = fullfile(ourRootDocFolder, whichSourceFolder);

ourBranch = 'main';
ourGitRoot = fullfile('https://github/iset/isetauto','blob',ourBranch,ourFolder);
ourFiles = dir(ourFolder);
for ii = 1:numel(ourFiles)
    if length(ourFiles(ii).name) > 1 && isequal(ourFiles(ii).name(end-1:end), '.m') % Filter our directories
        ourSourceFile = dockerWrapper.pathToLinux( ...
            fullfile(ourGitRoot,ourFiles(ii).name));
        % should rename this to .md once it works
        if ~isfolder(ourDocFolder)
            mkdir(ourDocFolder);
        end
        outFile = fullfile(ourDocFolder,ourFiles(ii).name);
        [fPath, fName, fExt] = fileparts(outFile);
        outFile = fullfile(fPath, [fName '.md']);
        ourDocFile = outFile;

        ourPrompt = [chatPrefix ourSourceFile];
        [status, result] = askChatGPT(ourPrompt);
        if status == 0
            disp('Success');
            writelines(result,ourDocFile);
        else
            frpintf('Error %s \n', result.message);
        end
    end
end

   