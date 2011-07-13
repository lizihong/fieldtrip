function retval = qsubexec(jobid)

% QSUBEXEC is a helper function to execute a job on the Torque or SGE batch
% queue system. Normally you should not start this function yourself, but
% rather use QSUBCELLFUN or QSUBFEVAL.
%
% The QSUBCELLUN, QSUBFEVAL, QSUBGET and QSUBEXEC functions provide an
% alternative to the peer distributed computing system.
%
% The QSUBEXEC function performs the following tasks
% - load the function name, input arguments and further options from the input file
% - evaluate the desired function on the input arguments using PEEREXEC
% - save the output arguments to an output file
%
% This function should be started from the linux command line as follows
%   qsub /opt/bin/matlab -r "qsubexec(jobid); exit"
% which starts the MATLAB executable, executes this function and exits
% MATLAB to leave your batch job in a clean state. The jobid is
% automatically translated into the input and output file names, which 
% have to reside on a shared network file system.
%
% See also QSUBCELLFUN, QSUBFEVAL, QSUBGET

% -----------------------------------------------------------------------
% Copyright (C) 2011, Robert Oostenveld
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/
% -----------------------------------------------------------------------

try
  
  p = getenv('HOME');
  f = sprintf('job_%d_input.mat', jobid);
  inputfile = fullfile(p, f);
  f = sprintf('job_%d_output.mat', jobid);
  outputfile = fullfile(p, f);
  
  tmp = load(inputfile);
  argin = tmp.argin; % this includes the function name and the input arguments
  optin = tmp.argin; % this includes the path setting, the pwd, the global variables, etc.
  
  % instead of reimplementing the whole try-catch execution, use the peerexec function to do the actual work
  [argout, optout] = peerexec(argin, optin);
  save(outputfile, 'argout', 'optout');
  
catch
  
  % this is to avoid MATLAB from hanging
  warning('an error was caught');
  
end % try-catch
