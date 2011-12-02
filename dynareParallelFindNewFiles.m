function [NewFilesFrom, NewFileList]=dynareParallelFindNewFiles(FileList,Parallel, PRCDir)

% PARALLEL CONTEXT
% In a parallel context, this function  checks if in 'dirName' and its sub-directory
% there are other files in addition to 'FileList'.
% If 'Yes' the variable 'NewFiles' is a list of these file.
%
%
% INPUTS
%  o dirName                     []   ...
%  o Parallel                    []   ...
%  o PRCDir                      []   ...

%  OUTPUTS
%  o NewFilesFrom          []   ...
%  o NewFileList           []   ...
%
% Copyright (C) 2009-2011 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.


NewFilesFrom={};

LfL=length(FileList);
                                        % The first call ...
NewFileList = dynareParallelListAllFiles('Root',PRCDir,Parallel);


LnFl=length(NewFileList);

RelativePosition=1;

for i=1:LnFl
    
    % Exception Handling
    
    % If you comment the code below all new file will be copied!
    
    % 1. The comp_status* files are managed separately.
    
    FiCoS=strfind(NewFileList{i},'comp_status_');
    if ~isempty(FiCoS)
        continue
    end
    
    % 2. For the time being is not necessary to always copy *.log
    %    and *.txt files.
    
    nC1 = strfind(NewFileList{i}, '.log');
    nC2 = strfind(NewFileList{i}, '.txt');
    
    if (~isempty(nC1) || ~isempty(nC2))
        continue
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    N=strmatch(NewFileList{i},FileList,'exact');
    if isempty(N)
        NewFilesFrom{RelativePosition}=NewFileList{i};
        RelativePosition=RelativePosition+1;
    end
end

