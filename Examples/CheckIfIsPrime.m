function [Reply] = CheckIfIsPrime(n)

% FUNCTION DESCRIPTION
% Is identical to nIsPrime_core.m, the difference is that many features of
% nIsPrime.m are removed to allow efficient nested calls.
%
% INPUTS
% o   n [integer]    The number for which some people ask us: "It is Prime?"
%
% OUTPUTS
% o   Reply [integer]   A integer with two possible values 1/0.


% Copyright (C) 2011-2011 ...
%
% This file is part of ...

Reply=1;

for v=2:floor(n/2),
    d=n/v;
    if d==ceil(d)
        Reply=0;
        break
    end
end



