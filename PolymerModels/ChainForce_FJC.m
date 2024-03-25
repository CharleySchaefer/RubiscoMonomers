% B=end-to-end length
% b=Kuhn length
% N=number of Kuhn segments
% Khaliullin and Schieber 2011
function F_by_kB=ChainForce_FJC(R,b,N, opt)
  Re_squared=b*b*N; % end-to-end length at rest
  Re_max=b*N;       % maximum end-to-end length
  
  Re0=sqrt(Re_squared);
  lambda=R/Re0;
  lmax=Re_max/Re0;
  if strcmp(opt, 'fene') % Finite extensibility
    for k=1:length(R)
      if R(k)<Re_max
  F_by_kB(k) = 3/(Re0)*((3*lmax^2-lambda(k).^2)./(lmax^2-lambda(k).^2))/((3*lmax^2-1)/(lmax^2-1)).*(lambda(k));
      else
        F_by_kB(k)=inf;
      end
    end
  else          % No finite extensibility (Hookean spring)
    F_by_kB=3*R/Re_squared; 
  end
  
end
