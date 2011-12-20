function [ output_args ] = ParallelConfiguration(In1,In2,In3,In4,In5)
% PARALLEL CONTEXT
% In a parallel context, this function is used to Initialize the computational
% enviroment according with the user request. If it is executet from
% Matlab use a graphical interface (ParallelConfigurationMatlab.gui). In
% octave take parameter from command line.
%
% INPUTS
% In1: The Configuration file name,
% In2: The Cluster Name,
% In3: Slave Always Open: Yes/No
% In4: Console Mode: Yes/No
% In5: Test Hardware: Yes/No
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

if exist('OCTAVE_VERSION')
    global Parallel Parallel_info
    
    Parallel=[];
    Parallel_info=[];
    
    Parallel_info.ClusterName='';
    Parallel_info.leaveSlaveOpen=0;
    Parallel_info.console_mode=1;
    % Default
    % Parallel_info.ConfigurationFileName='C:\Documents and Settings\Ivano\Application Data\dynare.ini';
    % Development
    Parallel_info.ConfigurationFileName='C:\DRAGONFLY\Development\Catlike Cluster.txt';
    
    [Parallel ErrorCode] = ParallelParser(Parallel_info.ConfigurationFileName,Parallel_info.ClusterName);
    if (ErrorCode)
        Parallel=[];
        return;
    end
    
    disp(' ');
    disp('Cluster Parsing ---> Ok!');
    disp(' ');
    
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
    
    
    
    % Deactivate some 'Parallel/Warning' message in Octave!
    % Comment the line 'warning('off');' in order to view the warning message
    % in Octave!
    
    if exist('OCTAVE_VERSION'),
        warning('off');
    end
    
    disp(' ');
    disp('A Cluster is Active!');
    disp(' ');
    
    % keyboard
    % ... to complete!
    
else
    % We can also passing the commanda line data at ParallelConfigurationMatlab:
    % ParallelConfigurationMatlab(In1,In2,In3,In4,In5);
      ParallelConfigurationMatlab;
end

end

