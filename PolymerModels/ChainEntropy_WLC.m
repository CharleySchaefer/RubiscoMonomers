% Worm-like chain
function S_by_kB=ChainEntropy_WLC(R,b,N,Lp)
  Re_squared=b*b*N; % end-to-end length at rest
  Re_max=b*N;       % maximum end-to-end length
  
  %lambda=R/sqrt(Re_squared);
  %lmax=Re_max/sqrt(Re_squared);
  l_by_lmax=R/Re_max;
  S_by_kB = (Re_max/(4*Lp))*( (1-l_by_lmax).^(-1) - l_by_lmax + 2*l_by_lmax.^2  );
end
