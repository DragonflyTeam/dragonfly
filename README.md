## DragonFly Framework Specifications ##


The DRAGONFLY package is a framework which allows to parallelize portions of Matlab/Octave codes that require low or no communication between parallel processes. The main idea is to manage with an easy interface the parallel processing for one common parallel paradigm "Embarrassingly parallel". The idea is to split a repetitive structures (nested functions) and then to share between all the processes selected for the executions. The processes can be distributed to different cores, CPUs or workstations, also considering the computational weight of the machine inside the parallel environment. Drangonfly will assign more or less workload according to the hardware capacity. In a nutshell, DragonFly will open new Octave/MATLAB instances for each parallel thread, i.e. in principle it would open as many Octave/MATLAB instances as allowed by the hardware configuration. It is under the user responsibility to make sure the number of MATLAB instances opened is compliant with her MATLAB license. 



***References:***

Azzini, I., Muresano, R., Ratto, M. Dragonfly: A multi-platform parallel toolbox for MATLAB/Octave, Computer Languages, Systems & Structures, 52, 2018, 21-42. 
https://doi.org/10.1016/j.cl.2017.10.002

Ratto, M., Azzini, I., Bastani, H., Villemot, S., Beta-version of parallel routines: user manual, (2011) MONFISPOL Grant no.: 225149, Deliverable 2.2.2, July 8, 2011.*


**Contents**

1. [**License**](#License)
2.  [**Developers Perspective**](#Perpective) 
3. [**Installation**](#Installation)
4. [**Execution**](#Execution)
5. [**Example**](#Example)


#License 

Most of the source files are covered by the GNU General Public Licence version
3 or later (there are some exceptions to this, see [license.txt](license.txt))



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