% B=end-to-end length
% b=Kuhn length
% N=number of Kuhn segments
% Khaliullin and Schieber 2011
function S_by_kB=ChainEntropy_FJC(R,b,N,lK, bbeta, opt)
  NK=b*N./lK;
  
  Re_max=b*N ;     % maximum end-to-end length
  S_by_kB=zeros(size(R));
  if strcmp(opt, 'fene')  % Finite extensibility
    for k=1:length(R)
      if R(k)<Re_max
     
  %    NK.*( 0.5*(R(k)./Re_max).^2 - log( 1-(R(k)./Re_max).^2 ) ); 
  %    a=1.5*log( 2*pi*bbeta.*NK/3 );
        S_by_kB(k)=NK.*( 0.5*(R(k)./Re_max).^2 - log( 1-(R(k)./Re_max).^2 ) ) + 1.5*log( 2*pi*bbeta.*NK/3 );
      else
        S_by_kB(k)=inf;
      end
    end
  % + log ... (N-dependent term, but independent of R)
  else                    % No finite extensibility (Hookean spring)
  % 
    Re_squared=lK.*lK.*NK; % end-to-end length at rest
    S_by_kB=1.5*(R.*R/Re_squared); 
  end
end
