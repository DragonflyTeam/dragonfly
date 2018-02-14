function [Replay rI] = Primelessthan(n)

% FUNCTION DESCRIPTION
% This function use n time the function nIsPrime.m (from 2 to n-1) to find all the prime
% numbers less than n. This funcution is used to show users how to use
% nested parallel functions. I.e. in a very minimal way!

% INPUTS
% o   n [integer]                       The number for which some people
%                                       ask us: Are You able to Find All Prime Numbers Less Than n?
%
% OUTPUT
% o   Reply [array]                     An array contained the divisors (if exist) of n.

% Copyright (C) 2011-2011 ...
%
% This file is part of ...


% STRATEGY:
% we simply call n-2 time the function nIsPrime.m (from 2 to n-1) to find all the prime
% numbers less than n.

startFor=2;
endFor=n;
tic;
[startFor endFor myoutput]=DRAGONFLY_Parallel_Start('i','startFor','endFor');
rI=0;
for i=startFor:endFor
    PnP=CheckIfIsPrime(i);
    if PnP==1
        Replay(rI+1)=i;        
        rI=rI+1;
    end
 end
DRAGONFLY_Parallel_Block_End(myoutput,'rI','0', 'Replay','1');
index=sum(rI);
toc;

