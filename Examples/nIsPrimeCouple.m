function [Replay] = nIsPrime(n)

% FUNCTION DESCRIPTION
% This function execute in serial and parallel the solution 1 DRAGONFLY User Manual.doc.

% INPUTS
% o   n [integer]                       The number for which some people ask us: "It is Prime?"
%                                       
%
% OUTPUT
% o   Reply [strct]                     A struct with one field: a string 'Yes/No' or 1/0.
%                                       User can add others field if necessary.
      Replay.isPrime='';


% PARALLEL CONTEXT
% The most computationally intensive part of this function may be executed
% in parallel. The code sutable to be executed in parallel on multi core or
% cluster machine (in general a 'for' cycle), is removed from this function
% and placed in nIsPrime_core.m funtion.
% The DRAGONFLY parallel package contain a set of pairs matlab functions
% that can be executed in parallel and called name_function.m and name_function_core.m.
% These set of function was developed as examples for the DRAGONFLY' users.
% Following this examples, users can rewrite an execute in parallel any
% kind of matlab function.
% In addition in DRAGONFLY parallel package we have second set of functions
% used to manage the parallel computation (the kernel code).
% These functions can be, if necessary, modified by the user.


% Copyright (C) 2011-2011 ...
%
% This file is part of ...


% STRATEGY:
% we simply split the set [2 n/2] into some parts: [2 n/numberOfSubsets],
% [n/numberOfSubsets+1 2*n/numberOfSubsets] ... in accord with the strategy
% developed in distributeJobs.m function, and then for this set (separately)
% we find (if exist) the first divisor. We do not save the divisors for n,
% but simply first find (if exist) the first divisor for the set [2 n/4]
% and after we find the first divisor for the set [n/numberOfSubsets+1 2*n/numberOfSubsets]
% etc.


% We note as when n is no a prime number some cores must do more work!
% We think that this is relatet with the distribution of divisors
% in the sub-intervals and with the strategy used from us to find the first of them.

% The n/2 set ...
m=floor(n/2);
% m=ceil(sqrt(n));

% Global variables. These variable contain ...
global Parallel Parallel_info


% Compute the global computational time!
tic;


% Snapshot of the current state of computing. It necessary for the parallel
% execution (i.e. to execute in a corretct way portion of code remotely or
% on many core). The mandatory variables for local/remote parallel
% computing are stored in localVars struct.

% localVars =   struct('v', v1, ...
%                      'v2',v2, ...
%                      ....
%                      'vn', vn);

localVars =   struct('n', n);


% The user don't want to use parallel computing.
% In this cases nIsPrime is computed sequentially.

if isempty(Parallel)
    disp(' ');
    disp('Serial Computing ...');
    disp(' ');
    myoutput= nIsPrime_core(localVars,1,m,0);
    CoreResponse=load(['Core0Data.txt']);
else
    
    % Parallel in Local or remote machine.
    
    % If we need global variables ...
    
    % Global variables for parallel routines.
    globalVars = struct('Parallel',Parallel, ...
                        'Parallel_info',Parallel_info);
    
    
    % If the function requires to copy files remotely ...
    
    % Which files have to be copied to run remotely:
    %     NamFileInput(1,:) = {'','FilaName1'};
    %     NamFileInput(2,:) = {'','FilaName2'};
    %     % ...
    %     NamFileInput(N,:) = {'','FilaNameN'};
     
    NamFileInput=[];
    
    disp(' ');
    disp('Go Parallel ...');
    disp(' ');
    
    [fout, nBlockPerCPU, totCPU] = masterParallel(Parallel, 1, m,NamFileInput,'nIsPrime_core', localVars, globalVars,Parallel_info);
    
    % Reshape the output in order to obtain myoutput and
    % obtain the data from files. 
    Temp=[];
    for j=1:length(fout),
        try
            Temp=[Temp, fout(j).ComputationalTime];
            CoreResponse(j)=load(['Core',num2str(j),'Data.txt']);
        catch
        end
    end
    myoutput.ComputationalTime=Temp;
end

CoreComputationalTime = myoutput.ComputationalTime;

% Delete computational traces.
delete(['Core*Data.txt']);


%Analyze the Cores Output.
Flag=0;

for i=1:length(CoreResponse),
    if CoreResponse(i)==0
        Flag=1;
        break;
    end
end

% Display results.
if Flag==0
    Replay.isPrime='Yes';
    disp(' ');
    sN=num2str(n);
    disp(['The numer ', sN ' is Prime?   ->  Yes!']);
    disp(' ');
    for i=1:length(CoreResponse)
        disp(['Computational time for Core ', num2str(i), ' is:']);
        disp(CoreComputationalTime(i));
        disp(' ');
    end
    
    disp('Total computational time is:');
    disp(toc);
    disp(' ');

    return
else
    Replay.isPrime='No';
    disp(' ');
    sN=num2str(n);
    disp(['The numer ', sN ' is Prime?   ->  No!']);
    disp(' ');
    for i=1:length(CoreResponse)
        disp(['Computational time for Core ', num2str(i), ' is:']);
        disp(CoreComputationalTime(i));
        disp(' ');
    end
 
    disp('Total computational time is:');
    disp(toc);
    disp(' ');
    
    return; 
end




