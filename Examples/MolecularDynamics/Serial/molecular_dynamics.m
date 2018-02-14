% function Result=molecular_dynamics(Np, Nd, Step_Num, Dt) 
% This code has been translated into Matlab to test the Dragonfly
% funcionality. 

% Matlab version Ronal Muresano, Ivano Azzino and Marco Ratto 
%Input Variables:

%          Np: Number of Particles in the simulation
%          Nd: Set the Dimension of the Problem
%          Step_Num: Defines the Number of Time Steps
%          Dt: Size of each time step

% The main program for MD_OPENMP.
% 
%   Discussion:
% 
%     MD implements a simple molecular dynamics simulation.
%     The program uses Open MP directives to allow parallel computation.
%     The velocity Verlet time integration scheme is used. 
%     The particles interact with a central pair potential.
%
%   Licensing:
% 
%     This code is distributed under the GNU LGPL license. 
% 
%   Modified:
%     30 July 2009
%   Author:
% 
%     Original FORTRAN77 version by Bill Magro.
%     C version by John Burkardt. 

%% 

  Nd= 3;
  Np=1800;
  Dt=0.0001;
  Step_Num=20;
  tic;
  Mass  = 1.0;
  Box(1:Nd) = 10;
  Force =zeros(Nd, Np);
 
  % Give the particles random positions within the box.
  % Initzialization Process  
 
 % Set Initial positions, Velocities, and accelerations
  Acc   =zeros(Nd, Np);
  Poss  =zeros(Nd, Np);
  Vel   =zeros(Nd, Np); 
  for i=1:Np
      Poss(:, i)=Box(:)*rand;
  end
  
  fprintf ('\n' );
  fprintf ('Matlab version \n' );
  fprintf ('Molecular Dynamics Program.\n' );
  fprintf ('Input Parameters \n' );
  fprintf ('Np, the number of particles in the simulation is %d\n',  Np);
  fprintf ('Nd, the number of dimensions in the simulation is %d\n', Nd);
  fprintf ('STEP_NUM, the number of time steps, is %d\n', Step_Num);
  fprintf ('DT, the size of each time step, is %f \n', Dt );
  fprintf ('\n' );

% Compute the forces and energies.
  fprintf ('Computing initial forces and energies.\n ');
  [Potential Kinetic Force]=compute(Np, Nd, Poss, Vel, Mass, Force);
  e0= Potential+Kinetic;
   
%  This is the main time stepping loop:  Compute forces and energies,
%   Update positions, velocities, accelerations.

    Step_print=0;
    Step_print_index=0;
    Step_print_num=5;
    Step=0;
    fprintf(' Step     Potencial Energy   Kinetic Energy    Relative Energy \n ');
    fprintf('  %d ,          %f ,            %f ,                %f \n', Step, Potential, Kinetic, (Potential+Kinetic-e0)/e0);
    Step_print_index = Step_print_index +1;
    Step_print =( Step_print_index * Step_Num)/ Step_print_num;
    for Step=2:Step_Num 
        [Potential Kinetic Force]=compute(Np, Nd, Poss, Vel, Mass, Force);
        if (Step== Step_print)
           fprintf('  %d ,          %f ,            %f ,                %f \n', Step, Potential, Kinetic, (Potential+Kinetic-e0)/e0);
           Step_print_index = Step_print_index +1;
           Step_print =( Step_print_index * Step_Num)/ Step_print_num;
        end
        [Poss Vel Acc]=update(Np, Nd, Poss, Vel, Force, Acc, Mass, Dt);
    end
    toc;
    
    
    
    

  

Result=1;
