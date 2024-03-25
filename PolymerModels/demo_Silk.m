function LinkerModels()
  clc; close all;
  kT=4;   % pN*nm
  N=550;   % Number of amino acids in a chain
  b=0.36; % [nm] step length of an amino acid
  lK=0.36 % Kuhn length
  
  NK=(b/lK)*N;     % Number of Kuhn segments
  Re0=lK*sqrt(NK); % End-to-end length at rest
  L0=b*N;          % Contour length
  lmax=L0/Re0;   

  % WLC model
  Lp=1;   % [nm] persistence length of polypeptide

  
  lambda=linspace(0,lmax,100);
  F_by_kB_FJC=ChainForce_FJC(lambda*Re0,lK,NK, 'fene');
  
  S_by_kB_FJC=ChainEntropy_FJC(lambda*Re0,b,N,lK, 1,'fene');
                           %   R,b,N,lK, bbeta, opt
  S_by_kB_FENE=ChainEntropy_FENE(lambda*Re0,3*(1/Re0).^2,lK*NK);

  figure
  subplot(2,1,1)
  plot(lambda, kT*F_by_kB_FJC, 'r', 'LineWidth', 2); hold on
  %plot(lambda, kT*F_by_kB_WLC, 'k', 'LineWidth', 2)
  %title('Force-extension curve')
  %legend('FJC', 'WLC')
  axis([0 lmax 0 150])
  xlabel('end-to-end distance [nm]')
  ylabel('F [nm]')
  
  subplot(2,1,2)
  plot(lambda, S_by_kB_FJC, 'r', 'LineWidth', 2); hold on
 % plot(lambda, S_by_kB_WLC, 'k', 'LineWidth', 2); hold on
  plot(lambda, S_by_kB_FENE, 'g', 'LineWidth', 2)
 % title('Free energy of extension curve')
 % legend('FJC', 'WLC')
 % axis([0 lmax 0 20])
 % xlabel('end-to-end distance [nm]')
 % ylabel('S/kB [-]')
end
