% Charley Schaefer, University of York, UK (2021)
% https://github.com/CharleySchaefer/ZiltoidLIB/utils
%
% Any integer B can be written as a partition, which 
% is a sum of integers b_m:
%
%  B = \sum_{m=1}^{N} b*m_b,
%
%  e.g. 4 = 1*1 + 2*0 + 3*1 + 4*0
%
% This function finds all possible values of b_m to product B
% and stores them in the global partitions array.

function partitions=integer_partitions(B,S)
  global partitions;
  partitions=[];
  nested_partitions_find(B,S,[]); % stores results in partitions
  partitions=flip(partitions,2);
end

function [par, B_new_residual]=nested_partitions_find(B_residual,b,par0)
  global partitions; 
  B_max=floor(B_residual/b);
  for i=0:B_max
    mb=B_max-i;
    B_new_residual=B_residual-b*mb;
    if B_new_residual==0
      par=[par0, mb, zeros(1,b-1)];
      partitions=[partitions; par];  % Add to global results
    elseif ~(B_new_residual>0 && b==1)
      par=[par0, mb];
      [par, B_new_residual]= ... 
         nested_partitions_find(B_new_residual,b-1,par);
    end
  end
end
