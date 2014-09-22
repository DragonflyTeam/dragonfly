function [Reply] = SimpleMathFunctions(n)

% FUNCTION DESCRIPTION
% This function is an example to describe how use
% DRAGONFLY matlab parallel toolbox ...

% INPUTS
% o   n [integer]                       The number for which some people ask us: "Compute the Square Roots for
%                                       all the integer <= n and then plot a graph!"
%                                       
%
% OUTPUT
% o   Reply [struct]                    A struct with one or two field:
%                                       the square roots and computational
%                                       time serial/parallel.
%                                       User can add others field if necessary.
   


% PARALLEL CONTEXT
% The most computationally intensive part of this function may be executed
% in parallel. The code sutable to be executed in parallel on multi core or
% cluster machine (in general a 'for' cycle), ...


% Copyright (C) 2011-2011 ...
%
% This file is part of ...



% The 'for' starting index.
% StartFor=1;

% The 'for' end index.
% EndFor=5;

%Which files have to be copied to run remotely ...
FileList=[];

% User Data used within 'for' cycle ...
SquareRoot=[];
CubicRoot=[];
Sum=[];

variablesForName(1).name='SquareRoot';
variablesForName(2).name='CubicRoot';
variablesForName(3).name='Sum';
 

% The portion of code between the two keywords 'DRAGONFLY_Parallel' and
% 'DRAGONFLY_Parallel_Block_End' is executed in parallel when the struct
% 'Parallel' exist and is not empty.

% Is it usefull transform it in a matlab script?
DragonflyOut=DRAGONFLY_Parallel(1,n,variablesForName,FileList);


for j=1:DragonflyOut.EndFor
    SquareRoot(j)=sqrt(j);
    CubicRoot(j)=(j)^(1/3);
    Sum(j)=SquareRoot(j)+CubicRoot(j);
end
DRAGONFLY_Parallel_Block_End;


% Display resuls ...

disp(SquareRoot);
disp(CubicRoot);
disp(Sum);


plot(SquareRoot);
hold on;
plot(CubicRoot);
plot(Sum);





