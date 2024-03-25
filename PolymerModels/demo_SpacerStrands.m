function demo_SpacerStrands()
  clc; close all;
  kT=4;   % pN*nm
  N=200;   % Number of amino acids in a chain
  b=0.36; % [nm] step length of an amino acid
  lK=0.36 % Kuhn length
  
  bbeta=1;
  lK_row=linspace(0.36,3,100)
  S_by_kB_FJC=zeros(100,2)
  for i=1:length(lK_row)
  'test'
  i
    lK=lK_row(i)
    %NK=(b/lK)*N;     % Number of Kuhn segments
    %Re0=lK*sqrt(NK); % End-to-end length at rest
    %lambda=7.7/Re0;
    %L0=b*N;          % Contour length
  %  lmax=L0/Re0;   
    S_by_kB_FJC(i,:)=ChainEntropy_FJC([7.7 10.9],b,N,lK,bbeta, 'fene');
  
  end
  S_by_kB_FJC=S_by_kB_FJC';
  size(S_by_kB_FJC)
  
  P2=exp(-S_by_kB_FJC(2,:))./(exp(-S_by_kB_FJC(2,:))+exp(-S_by_kB_FJC(1,:)));
  size(P2)
  size(lK_row)
  plot(lK_row, P2)

  
end
