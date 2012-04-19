function fParallel(fblck,nblck,whoiam,ThisMatlab,fname)
% PARALLEL CONTEXT
% In a parallel context, this function is launched on slave
% machines, and acts as a wrapper around the function containing the
% computing task itself.
%
% INPUTS
%  o fblck [int]        index number of the first thread to run in this
%                       MATLAB instance
%  o nblck [int]        number of threads to run in this
%                       MATLAB instance
%  o whoiam [int]       index number of this CPU among all CPUs in the
%                       cluster
%  o ThisMatlab [int]   index number of this slave machine in the cluster
%                       (entry in options_.parallel)
%  o fname [string]     function to be run, containing the computing task
%
% OUTPUTS
%   None
%
% Copyright (C) 2006-2011 Dynare Team
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

global funcName

funcName=fname;

warning off;
diary off;

delete( [fname,'_',int2str(whoiam),'.log']);
diary( [fname,'_',int2str(whoiam),'.log']);

% Configure dynare environment.
% dynareroot = dynare_config();

% Load input data.
load( [fname,'_input.mat'])

if exist('fGlobalVar') && ~isempty (fGlobalVar)
    globalVars = fieldnames(fGlobalVar);
    for j=1:length(globalVars),
        eval(['global ',globalVars{j},';'])
        evalin('base',['global ',globalVars{j},';'])
    end
    struct2local(fGlobalVar);
    % Create global variables in the base workspace as well.
    evalin('base',['load( [''',fname,'_input.mat''],''fGlobalVar'')'])
    evalin('base','struct2local(fGlobalVar)');
end

fInputVar.Parallel = Parallel;


% Launch the routine to be run in parallel.
try,
    tic,
    
    fOutputVar = feval(fname, fInputVar ,fblck, nblck, whoiam, ThisMatlab);
    toc,
    if isfield(fOutputVar,'OutputFileName'),
        OutputFileName = fOutputVar.OutputFileName;
    else
        OutputFileName = '';
    end
    if(whoiam)
        % Save the output result.
        save([ fname,'_output_',int2str(whoiam),'.mat'],'fOutputVar' )
    end
    if isfield(fOutputVar,'CloseAllSlaves'),
        CloseAllSlaves = 1;
        fOutputVar = rmfield(fOutputVar,'CloseAllSlaves');
        save([ fname,'_output_',int2str(whoiam),'.mat'],'fOutputVar' )
        savedok=0;
        while savedok==0
            try
                save(['comp_status_',funcName,int2str(whoiam),'.mat'],'CloseAllSlaves');
                savedok=1;
            catch
                pause(0.05)
            end
        end
    end
    
    disp(['fParallel ',int2str(whoiam),' completed.'])
catch,
    theerror = lasterror;
    if strfind(theerror.message,'Master asked to break the job')
        fOutputVar.message = theerror;
        save([ fname,'_output_',int2str(whoiam),'.mat'],'fOutputVar' )
        waitbarString = theerror.message;
    else
        disp(['fParallel ',int2str(whoiam),' crashed.'])
        fOutputVar.error = theerror;
        save([ fname,'_output_',int2str(whoiam),'.mat'],'fOutputVar' )
        waitbarString = theerror.message;
        %       waitbarTitle=['Metropolis-Hastings ',options_.parallel(ThisMatlab).ComputerName];
        if Parallel(ThisMatlab).Local,
            waitbarTitle='Local ';
        else
            waitbarTitle=[Parallel(ThisMatlab).ComputerName];
        end
        fMessageStatus(NaN,whoiam,waitbarString, waitbarTitle, Parallel(ThisMatlab));
    end
    
end
diary off;
delete(['P_',fname,'_',int2str(whoiam),'End.txt']);


exit;
