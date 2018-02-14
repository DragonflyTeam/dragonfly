function [Matrix] = MatrixGeneral(n);

% FUNCTION DESCRIPTION

% We try to resolve the problems related to:
% Matrix (re)Compition and ... Nested for cycles, and Mulidimensional array ...



% Ma=ones(n, n);
% startFor=1;
% endFor=n;
% Cuccu=35;
% 
% [startFor endFor myoutput]=DRAGONFLY_Parallel_Start('j','startFor','endFor');
% for j=startFor: endFor
%     
%     if j<3
%         Ma(j,j)=j;%Ma(j,j)+Ma(j,j) +j;
%         Ma(n,n)=-1;
%     else
%         Ma(j,j)=2*j;%Ma(j,j)+Ma(j,j) +j;
%         Ma(n,n)=-1;
%     end
%     Cuccu=35;
% end
% DRAGONFLY_Parallel_Block_End(myoutput,'Ma','1','Cuccu','1');
% 
% disp(Ma);
% % disp(Cuccu);
% Matrix=Ma;

startFor=1;
endFor=n;

matrix_B1=rand(n,n);
C1=rand(n,n);

disp('Testing Wise Multiplication of two Random Matrixes of size n' );
disp('Computing Example...' );
tic;
[startFor endFor myoutput]=DRAGONFLY_Parallel_Start('i','startFor','endFor');
Matrix=zeros(endFor-startFor +1,n);
for i=startFor:endFor
    for j=1:n 
           Matrix(i,j)= matrix_B1(i,j) * C1(i,j);
    end
end
DRAGONFLY_Parallel_Block_End(myoutput,'Matrix','0');
toc;

% Display results ...
disp('     ');
disp('Matrixes Multiplied');
disp('     ');
toc

