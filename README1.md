## DragonFly Framework Specifications ##


DRAGONFLY package is a framework which allows us to parallelize portion of Matlab/Octave codes that require low or not communications between parallel processes. The main idea is to manage with an easy interface the parallel processing for one common parallel paradigm "Embarrassingly parallel". The idea is to split a repetitive structures (nested functions) and then to share between all the processes selected for the executions. The processes can be executed in the different core, CPUs or machines considering the computational weight of the machine inside the parallel environment. Then, Drangonfly will assign more or less workload according to the hardware capacity but It is always the user to be responsible to the licenses permission to execute Dragonfly.... 



***References:***

*Azzini I., Girardi R. and Ratto M., Parallelization of Matlab codes under Windows platform for Bayesian estimation: A Dynare application, DYNARE CONFERENCE September 10-11, 2007 Paris School of Economics.*

*Azzini I., Ratto M., Parallel DYNARE Toolbox, 17th International Conference on Computing in Economics and Finance (CEF 2011). Society for Computational Economics Sponsored by the Federal Reserve Bank of San Francisco, June 29 through July 1, 2011.

Ratto, M., Report on alternative algorithms efficiency on different hardware specifications and Alpha-version of parallel routines, (2010) MONFISPOL Grant no.: 225149, Deliverable 2.2.1, March 31, 2010.

Ratto, M., Azzini, I., Bastani, H., Villemot, S., Beta-version of parallel routines: user manual, (2011) MONFISPOL Grant no.: 225149, Deliverable 2.2.2, July 8, 2011.*


**Contents**

1. [**License**](#License)
2.  [**Developers Perspective**](#Perpective) 
3. [**Installation**](#Installation)
4. [**Execution**](#Execution)
5. [**Example**](#Example)


#License 

Most of the source files are covered by the GNU General Public Licence version
3 or later (there are some exceptions to this, see [license.txt](license.txt) in



#Installation

**Requirements:**

***For a Windows cluster:***

1. A standard Windows network (SMB) must be in place;
2. PsTools (Russinovich, 2009) must be installed in the path of the master

**Windows machine;**

3. the Windows user on the master machine has to be user of any other
slave machine in the cluster, and that user will be used for the remote
computations.

***For a UNIX grid***


1. SSH must be installed on the master and on the slave machines; the UNIX user on the master machine has to be user of any other slave machine in the cluster, and that user will be used for the remote computations;  SSH keys must be installed so that the SSH connection from the master to the slaves can be done without passwords, or using an SSH agent.

#Execution 



#Example


#Developers 