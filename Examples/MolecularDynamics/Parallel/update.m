function [Poss1 Vel1 Acc1]= update(Np, Nd, Poss1, Vel1,Force1, Acc1, Mass1, Dt)
%   Purpose:
% 
%     UPDATE updates positions, velocities and accelerations.
% 
%   Discussion:
%      The time integration is fully parallel.
%      A velocity Verlet algorithm is used for the updating.
%   x(t+dt) = x(t) + v(t) * dt + 0.5 * a(t) * dt * dt
%   v(t+dt) = v(t) + 0.5 * ( a(t) + a(t+dt) ) * dt
%   a(t+dt) = f(t) / m
% 
%   Licensing:
% 
%     This code is distributed under the GNU LGPL license. 
% 
%   Modified:
% 
%     17 April 2009
% 
%   Author:
% 
%     Original FORTRAN77 version by Bill Magro.
%     C version by John Burkardt.
% 
%   Parameters:
% 
%     Input, int NP, the number of particles.
% 
%     Input, int ND, the number of spatial dimensions.
% 
%     Input/output, double POS[ND*NP], the position of each particle.
% 
%     Input/output, double VEL[ND*NP], the velocity of each particle.
% 
%     Input, double F[ND*NP], the force on each particle.
% 
%     Input/output, double ACC[ND*NP], the acceleration of each particle.
% 
%     Input, double MASS, the mass of each particle.
% 
%     Input, double DT, the time step.
% */
% {
 Rmass = 1.0 / Mass1;
 
  for j=1:Np,
      for i=1:Nd,
           Poss1(i,j)= Poss1(i,j)+ Vel1(i,j)*Dt+0.5*Acc1(i,j)*Dt*Dt;
           Vel1(i,j) = Vel1(i,j) + 0.5* Dt * (Force1(i,j)* Rmass* Acc1(i,j));
           Acc1(i,j)= Force1(i,j)*Rmass;
      end
  end
 
