% Worm-like chain
function F_by_kB=ChainForce_WLC(R,b,N,Lp)
  Re_squared=b*b*N; % end-to-end length at rest
  Re_max=b*N;       % maximum end-to-end length
  
  %lambda=R/sqrt(Re_squared);
  %lmax=Re_max/sqrt(Re_squared);
  l_by_lmax=R/Re_max;
  F_by_kB = ( (1-l_by_lmax).^(-2) - 1 + 4*l_by_lmax  )/(4*Lp);
end
