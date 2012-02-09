function [SomeOutput] = ParallelConfiguration(In1,In2,In3,In4,In5)

% PARALLEL CONTEXT
% In a parallel context, this function is used to Initialize the computational
% enviroment (usiug command line) according with the user request.
%
% INPUTS
% In1: The Configuration file name or,
% In2: The Cluster Name or,
% In3: Slave Always Open: Yes/No or,
% In4: Console Mode: Yes/No or,
% In5: Test Hardware: Yes/No!
%
%
% OUTPUTS
% [ ... ]
%
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

global Parallel Parallel_info


if isempty(Parallel) || isempty(Parallel_info)
    Parallel=[];
    Parallel_info=[];
    
    % Default Setting:
    Parallel_info.ConfigurationFileName=([getenv('APPDATA'),'\dynare.ini']);
    Parallel_info.ClusterName='';
    Parallel_info.leaveSlaveOpen=0;
    if exist('OCTAVE_VERSION')
        Parallel_info.console_mode=1;
    else
        Parallel_info.console_mode=0;
    end
    Parallel_info.TestCluster=0;
end

if nargin ~= 0
    
    % Is a 'Close Slave' form?
    KeyWord00='Close Slave';
    KeyWord00(isspace(KeyWord00)) = '';
    KeyWord00=lower(KeyWord00);
    if exist('In2')
        In12=[In1 In2];
        In12=lower(In12);
    else
        In12=In1;
        In12=lower(In12);
    end
    
    if strfind(KeyWord00,In12)
        try
            if isfield(Parallel_info,'RemoteTmpFolder')
                s=warning('off');
                closeSlave(Parallel, Parallel_info.RemoteTmpFolder);
                disp(' ');
                disp('Slave(s), closed!');
                disp(' ');
                s=warning('on');
            end
            return;
        catch
            s=warning('on');
            disp(' ');
            disp('Some error(s)occurred while try to close the "Slaves"!');
            disp(' ');
            return;
        end
    end
    
    
    Parallel=[];
    Parallel_info=[];
    
    % Default Setting:
    Parallel_info.ConfigurationFileName=([getenv('APPDATA'),'\dynare.ini']);
    Parallel_info.ClusterName='';
    Parallel_info.leaveSlaveOpen=0;
    if exist('OCTAVE_VERSION')
        Parallel_info.console_mode=1;
    else
        Parallel_info.console_mode=0;
    end
    Parallel_info.TestCluster=0;
    
    
    KeyWord01='Console';
    KeyWord01 = lower(KeyWord01);
    KeyWord02='Open';
    KeyWord02 = lower(KeyWord02);
    KeyWord021='Leave';
    KeyWord021 = lower(KeyWord021);
    KeyWord03='Test';
    KeyWord03 = lower(KeyWord03);
    
    
    if exist('In1')
        UserInputs{1}=In1;
    end
    if exist('In2')
        UserInputs{2}=In2;
    end
    if exist('In3')
        UserInputs{3}=In3;
    end
    if exist('In4')
        UserInputs{4}=In4;
    end
    if exist('In5')
        UserInputs{5}=In5;
    end
    
    for i=1: length(UserInputs)
        
        InTemp=lower(UserInputs{i});
        
        if ~isempty(regexp(InTemp,KeyWord01))
            Parallel_info.console_mode=1;
            continue
        end
        
        if ~isempty(regexp(InTemp,KeyWord02)) || ~isempty(regexp(InTemp,KeyWord021))
            Parallel_info.leaveSlaveOpen=1;
            continue
        end
        if ~isempty(regexp(InTemp,KeyWord03))
            Parallel_info.TestCluster=1;
            continue
        end
        
        if strfind(Parallel_info.ConfigurationFileName,([getenv('APPDATA'),'\dynare.ini']))
            Parallel_info.ConfigurationFileName=UserInputs{i};
            
            if i<length(UserInputs)
                if ~isempty(regexp(lower(UserInputs{i+1}),KeyWord01))
                    Parallel_info.console_mode=1;
                    continue
                end
                if ~isempty(regexp(lower(UserInputs{i+1}),KeyWord02)) || ~isempty(regexp(lower(UserInputs{i+1}),KeyWord021))
                    Parallel_info.leaveSlaveOpen=1;
                    continue
                end
                if ~isempty(regexp(lower(UserInputs{i+1}),KeyWord03))
                    Parallel_info.TestCluster=1;
                    continue
                end
                Parallel_info.ClusterName=UserInputs{i+1};
            end
        end
    end
end

if exist('OCTAVE_VERSION')
    Parallel_info.console_mode=1;
end

% Deactivate some 'Parallel/Warning' message in Octave!
% Comment the line 'warning('off');' in order to view the warning message
% in Octave!

if exist('OCTAVE_VERSION'),
    warning('off');
end


[Parallel ErrorCode] = ParallelParser(Parallel_info.ConfigurationFileName,Parallel_info.ClusterName);

if (ErrorCode)
    Parallel=[];
    return;
end

disp(' ');
disp('Cluster Parsing ---> Ok!');
disp(' ');

parallelroot = strrep(which('ParallelConfiguration'),'ParallelConfiguration.m','');
Parallel_info.parallelroot=parallelroot;
% To close the slave ...
addpath([parallelroot,filesep,'exit_from_parallel']);

% This is simple and check!
% The default value for the field MatlabOctavePath now is 'matlab' or
% 'octave'. Then if the field is empty it is necessary to fill it with the
% default value.

for j=1:length(Parallel),
    if isempty(Parallel(j).MatlabOctavePath),
        if exist('OCTAVE_VERSION')
            Parallel(j).MatlabOctavePath = 'octave';
        else
            Parallel(j).MatlabOctavePath = 'matlab';
        end
    end
end


% Necessary for hybrid computig when we have(Octave (master) -> Matlab (slaves)

for j=1:length(Parallel),
    if exist('OCTAVE_VERSION')
        strTemp=Parallel(j).MatlabOctavePath;
        strTemp=lower(strTemp);
        if ~isempty(strfind(strTemp, 'matlab'))
            default_save_options('-v7');
        end
    end
end


% Invoke masterParallel with 8 arguments and the last equal to 1. With this shape
% for input data, masterParallel only create a new directory for remote
% computation. The name of this directory is time depending. For local
% parallel computations with Strategy == 1 delete the traces (if exists) of
% previous computations.

% If the computation is only 'local' this value is unchanched!
Parallel_info.RemoteTmpFolder='';

delete(['P_slave_*End.txt']);
masterParallel(Parallel,[],[],[],[],[],[],Parallel_info,1);


%  We sort in the user CPUWeight and most important the Parallel vector
%  in accord with this operation.

lP=length(Parallel);
for j=1:lP
    CPUWeight(j)=str2num(Parallel(j).NodeWeight);
end

NewPosition=ones(1,lP)*(-1);
CPUWeightTemp=ones(1,lP)*(-1);

CPUWeightTemp=CPUWeight;

for i=1:lP
    [NoNServe mP]=max(CPUWeightTemp);
    NewPosition(i)=mP;
    CPUWeightTemp(mP)=-1;
end

CPUWeight=sort(CPUWeight,'descend');


for i=1:lP
    ParallelTemp(i)=Parallel(NewPosition(i));
end

Parallel=[];
Parallel=ParallelTemp;

if(Parallel_info.TestCluster)
    AnalyseComputationalEnvironment(Parallel, Parallel_info);
end

if(Parallel_info.TestCluster)
    disp(' ');
    disp('A Cluster Tested and Active!');
    disp(' ');
else
    disp(' ');
    disp('A Cluster is Active!');
    disp(' ');
end

end

