function LinkerModels()
  clc; close all;
  kT=4;   % pN*nm
  N=10;   % Number of amino acids in a chain
  b=0.36; % [nm] step length of an amino acid
  lK=0.36 % Kuhn length
  
  NK=(b/lK)*N;     % Number of Kuhn segments
  Re0=lK*sqrt(NK); % End-to-end length at rest
  L0=b*N;          % Contour length
  lmax=L0/Re0;   

  % WLC model
  Lp=0.36;   % [nm] persistence length of polypeptide

  
  lambda=linspace(0,lmax,100);
  F_by_kB_FJC=ChainForce_FJC(lambda*Re0,lK,NK, 'fene');
  F_by_kB_WLC=ChainForce_WLC(lambda*Re0,b,N,Lp);
  S_by_kB_FJC=ChainEntropy_FJC(lambda*Re0,lK,NK, 'fene');
  S_by_kB_WLC=ChainEntropy_WLC(lambda*Re0,b,N,Lp);

  figure
  subplot(2,1,1)
  plot(lambda, kT*F_by_kB_FJC, 'r', 'LineWidth', 2); hold on
  plot(lambda, kT*F_by_kB_WLC, 'k', 'LineWidth', 2)
  title('Force-extension curve')
  legend('FJC', 'WLC')
  axis([0 lmax 0 150])
  xlabel('end-to-end distance [nm]')
  ylabel('F [nm]')
  
  subplot(2,1,2)
  plot(lambda/lmax, log10(S_by_kB_FJC), 'r', 'LineWidth', 2); hold on
  plot(lambda/lmax, log10(S_by_kB_WLC), 'k', 'LineWidth', 2)
  title('Free energy of extension curve')
  #legend('FJC', 'WLC')
  #axis([0 lmax 0 20000])
  xlabel('end-to-end distance [nm]')
  ylabel('S/kB [-]')
end
