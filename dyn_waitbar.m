function h = dyn_waitbar(prctdone, varargin)
% h = dyn_waitbar(prctdone, varargin)
% adaptive waitbar, producing console mode waitbars with
% octave and when console_mode=1

%
% Copyright (C) 2011 Dynare Team
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
global options_
persistent running_text newString
persistent whoiam Parallel

if iscell(prctdone)
    whoiam = prctdone{2};
    Parallel = prctdone{3};
    prctdone=prctdone{1};
end

if prctdone==0,
    init=1;
    if isempty(whoiam)
        whoiam=0;
    end
else
    init=0;
end
if nargout,
    h=[];
end

if ~whoiam
    
    if exist('OCTAVE_VERSION') || options_.console_mode,
                
        if init,
            diary off;
            running_text = varargin{1};
            newString='';
            return;
        elseif nargin>2,
            running_text =  varargin{2};
        end
        
        if exist('OCTAVE_VERSION'),
            printf([running_text,' %3.f%% done\r'], prctdone*100);
        else
            s0=repmat('\b',1,length(newString));
            newString=sprintf([running_text,' %3.f%% done'], prctdone*100);
            fprintf([s0,'%s'],newString);
        end
        
    else
        if nargout,
            h = waitbar(prctdone,varargin{:});
        else
            waitbar(prctdone,varargin{:});
        end
    end
    
else
    if init,
        running_text = varargin{1};
    elseif nargin>2
        running_text = varargin{2};
    end
    if Parallel.Local,
        waitbarTitle=['Local '];
    else
        waitbarTitle=[Parallel.ComputerName];
    end
    fMessageStatus(prctdone,whoiam,running_text, waitbarTitle, Parallel);
end

