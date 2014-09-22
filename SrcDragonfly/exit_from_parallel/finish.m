% Scrip used to close, if exist
% the slaves. This code must be execut onfly by "master2 Matalab!

global Parallel Parallel_info

try
    if isfield(Parallel_info,'RemoteTmpFolder')
        s=warning('off');
        closeSlave(Parallel, Parallel_info.RemoteTmpFolder);
        disp(' ');
        disp('Slave(s), closed!');
        disp(' ');
        s=warning('on');
    end
catch
    s=warning('on');
    disp(' ');
    disp('Some error(s)occurred while try to close the "Slaves"!');
    disp(' ');
end

rmpath([Parallel_info.parallelroot,filesep,'exit_from_parallel']);