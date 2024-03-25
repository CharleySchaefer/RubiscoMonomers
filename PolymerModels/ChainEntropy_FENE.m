% z:  end to end distance in nm
% k:  spring constant in 1/nm^2
% R0: contour length
%
% Properties: equilibrium end-to-end length Re=sqrt(3/k)
%
function S_by_kB=ChainEntropy_FENE(z,k,R0)
  
  zbyR0=z/R0;
  S_by_kB = -0.5*k*R0*R0*log(1-zbyR0.*zbyR0);
end
