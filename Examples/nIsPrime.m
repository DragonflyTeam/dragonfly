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
Replay=1;


% PARALLEL CONTEXT
% The most computationally intensive part of this function may be executed
% in parallel. The code suitable to be executed in parallel on multi core or
% cluster machine (in general a 'for' cycle), ...


% Copyright (C) 2011-2011 ...
%
% This file is part of ...


% STRATEGY:
% ...

% The n/2 set ...
m=floor(n/2);

%Which files have to be copied to run remotely ...
FileList=[];

% User Data used within 'for' cycle ...


variablesForName(1).name='Replay';
variablesForName(3).name='n';
variablesForName(2).name='m';

DragonflyOut=DRAGONFLY_Parallel(2,m,variablesForName,FileList);

for v=2:m,
    d=n/v;
    if d==ceil(d)
        % DIVISOR FOUND!
        Replay=0;
        break
    end
end
DRAGONFLY_Parallel_Block_End;


if Replay==1;
    disp(' ');
    str=['The number ',num2str(n),' is prime!'];
    disp(str);
    disp(' ');
else
    disp(' ');
    str=['The number ',num2str(n),' is not prime!'];
    disp(str);
    disp(' ');
end
