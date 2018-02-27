function [M] = Matrixmultiplication(n, Test)
% This is a simple test to prove the performance of Dragonfly, We have
% designed the matrix multiplication using Serial (Test=2), Matlab Parallel (Test=1) and Dragonfly (Test=0) 

A(1:n, 1:n)=1;
B(1:n, 1:n)=2;

if (Test==0)
    startFor=1;
    endFor=n;
    disp('Dragonfly Matrix Multiplication');
    tic;
    index=1;
    [startFor endFor myoutput]=DRAGONFLY_Parallel_Start('i','startFor','endFor');
    for i=startFor:endFor
        for j=1:n
            tmp=0;
            for k=1:n
                tmp  = tmp + A(i,k)*B(k,j);
            end
            M(index,j)=tmp;
        end
        index=index+1;
    end
    DRAGONFLY_Parallel_Block_End(myoutput,'M','0');
    toc;
else
    if (Test==1)
        tic;
        disp('Par Matlab Matrix Multiplication');
        parfor i=1:n
            for j=1:n
                tmp=0;
                for k=1:n
                    tmp  = tmp + A(i,k)*B(k,j);
                end
                M(i,j)=tmp;
            end
        end
        toc;
    else
        disp('Serial Matrix Multiplication');
        tic;
        for i=1:n
            for j=1:n
                tmp=0;
                for k=1:n
                    tmp  = tmp + A(i,k)*B(k,j);
                end
                M(i,j)=tmp;
            end
        end
        toc;
    end
end
    

