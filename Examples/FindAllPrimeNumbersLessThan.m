function [Replay] = FindAllPrimeNumbersLessThan(n,init)

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
Replay=[];


% Copyright (C) 2011-2011 ...
%
% This file is part of ...


% STRATEGY:
% we simply call n-2 time the function nIsPrime.m (from 2 to n-1) to find all the prime
% numbers less than n.
tic
% For test ... 
persistent Normaliz

if nargin==1 || isempty(init),
    init=0;
end
if init==1,
    Normaliz=1;
end


%Which files have to be copied to run remotely ...
FileList=[];

% User Data used within 'for' cycle ...
rI=1;

% For test ... Variables (local) Defined before the keyword DRAGONFLY_Parallel_Start!
% and used inside cycle 'for' ...
 BigPrimeInSubSequence='Null';
 PartialCounterSummation=0;


startFor=1;
endFor=n;

[startFor endFor myoutput]=DRAGONFLY_Parallel_Start('i','startFor','endFor',{'','testing.m'});
%CheckIfIsPrime

for i=startFor:endFor
    
    PnP=CheckIfIsPrime(i);
    if PnP==1
        Replay(rI)=i;
        
        % For test ...
        BigPrimeInSubSequence=num2str(Replay(rI));
        PartialCounterSummation=PartialCounterSummation+i;
        
        rI=rI+1;
    end
    % For test ...
    BigPrimeInSubSequence=[BigPrimeInSubSequence '_'];
    Cocco=2+Normaliz;
    Talpa=88;
end


DRAGONFLY_Parallel_Block_End(myoutput,'Replay','1','rI','1');


%  Display results ...
 disp(' ');
 disp(['Prime Less Than ',num2str(1),' and ', num2str(n), ' are:' ]);
 disp(' ');
 disp(num2str(Replay));
 disp(' ');


toc



