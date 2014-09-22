function [myoutput] = nIsPrime_core(myinputs,sPoint,ePoint,whoiam,ThisMatlab)

% FUNCTION DESCRIPTION
% This function contain the most computationally intensive portion of code
% in nIsPrime (the 'for c = 1:m' loop). The branches in 'for'
% cycle can independent then suitable to be executed in parallel way.
% Nevertheless our code is able to manage a kind of dpedence between the
% 'for' branches, i.e. our code manage efficiently the keyword 'break'
% when necessary.
%
% INPUTS
%   o myimput            [struc]     The mandatory variables for local/remote
%                                    parallel computing obtained from nIsPrime.m
%                                    function.
%   o sPoint and ePoint  [integer]   The branch(s) of cycle for
%   o whoiam             [integer]   In concurrent programming a modality to refer to the differents thread
%                                    running in parallel is needed.
%                                    The integer whoaim is the integer that allows us to distinguish between them.
%                                    Then it is the index number of this CPU among all CPUs in the cluster.
%                                    If whoiam is equalo to ZERO:
%
%   o ThisMatlab         [integer]   Allows us to distinguish between the
%                                    'main' matlab, the slave matlab worker, local matlab, remote matlab,
%                                     ... Then it is the index number of this slave machine in the cluster.
%                                     Matlab refer also OCTAVE or another generic scientific software.
%                                    If ThisMatlab are not in input ...
%
%
% OUTPUTS
%   o myoutput  [struc]
%               If executed without parallel is the original output of 'for c =
%               sPoint:ePoint' otherwise is a portion of it computed on a specific core or
%               remote machine. In this case:
%                                            Core'Number'ComputationalTime;
%               These values is not necessary for nIsPrime computing (the
%               results are alse saved in a text files), is only for
%               example.
% ALGORITHM
%   Portion of nIsPrime.m
%
%
% SPECIAL REQUIREMENTS.
%   None.

% Memorize the cores computational time!
tic;

% Check the numbers of input variable.
global Parallel Parallel_info

% Serial Computation!
if nargin<4,
    whoiam=0;
end

% Reshape 'myinputs' for local computation.
% In order to avoid confusion in the name space, the instruction struct2local(myinputs) is replaced by:
n=myinputs.n;

% Display Local/Remote computational state in graphical or textual mode.

if whoiam
    prct={0,whoiam,Parallel(ThisMatlab)};
    hl = dyn_waitbar(prct,['Please wait... '],'Name', 'Sequential Serarch of Prime Numbers');
else
    hl = dyn_waitbar(0,['Please wait... '],'Name', 'Sequential Serarch of Prime Numbers');
end



% Memorize if a specific core (in a specific subset) found a divisor for n!
Response=1;

% Split the set m in continuously subset across the cores.
for v=sPoint+1:ePoint+1,
    
    d=n/v;
    
    if d==ceil(d)
        
        % Display Local/Remote computational state in graphical or textual mode.
%         if whoiam
            dyn_waitbar(1,hl);
%         end
        
        % DIVISOR FOUND!
        Response=0;
        
        % The CloseAllSlaves variable is used to manage in optimal way the
        % 'break' condition within 'for' cycles:
        % when a core find a divisor send a message to the other cores to
        % stop the computation.
        
        % If the user do not need to use this features simply comment the
        % 4 code lines below.
        if whoiam
            myoutput.CloseAllSlaves = 1;
        end
        break
    end
    
    % Display Local/Remote computational state in graphical or textual mode.
    if mod(v,max(10000,fix(ePoint/100)))==0,
        dyn_waitbar((v-sPoint)/(ePoint-sPoint),hl);
    end
    
end

% NO DIVISOR FOUND!!

% Save data for a specific core on a file.
% The file name can contain a way to differentiate themselves from other
% cores/subset data results, for example the 'whoiam' variable.

if exist('OCTAVE_VERSION')
    save('-ascii',['Core',num2str(whoiam),'Data.txt'],'Response');
else
    save(['Core',num2str(whoiam),'Data.txt'],'Response', '-ASCII');
end

% Save the specif core data: (See also above)
% this operation is not strictly necessary (the result are also in a text file) is only
% a example on how to use 'myoutput' in parallel computing.

ComputationalTime=toc;
myoutput.ComputationalTime =ComputationalTime;

% if whoiam
    dyn_waitbar_close(hl);
% end


