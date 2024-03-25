%====================================================
% FITTING ALGORITHM
%   Input
%     tdat: array with times 
%     pdat: array with fractions of cells with an aggresome at time tdat 
%   Output
%     param:     [n,J] 
%     param_std: uncertainty in [n, J]
%     Rsquared:  Fit quality
function [param, param_std, Rsquared, chisquare] = FitLinearOffset(xdat, ydat, yerr, slope)
  %----------------------------------------------------
  % FIT
  options = optimset(...   
            'MaxIter',1000,...
            'Display','off',...
            'MaxFunEvals',100000,...
            'TolX',1e-10,...
            'TolFun',1e-10);%,...
%             'Algorithm','levenberg-marquardt'); % 'trust-region-reflective'

	param0=[ones(size(xdat)), xdat]\ydat ;% linear regression
          param0=param0(1);
[param, resnorm, residual, qqq1, qqq2, qqq3, jacobian]=...
       lsqnonlin(@(param)costlin(param, xdat, ydat, yerr, slope), param0, [], [], options);

  %----------------------------------------------------
  % ERROR ANALYSIS

  chisquare= resnorm; 
  Npar = 1;                              % Number of fit parameters
  dof  = length(ydat) - Npar;            % Degrees of freedom
p=chi2cdf(chisquare, dof);
  C          = inv(full(jacobian)'*full(jacobian));
  covarpar   = chisquare/dof*C;            % Variance-covariance matrix
  param_std  = sqrt(diag(covarpar))';    % Standard deviation (STD)

  corr_mat = C./sqrt(diag(C)*diag(C)');  % Correlation matrix 

  Rsquared=1-resnorm/(sum( (ydat-mean(ydat)).^2 ) );
end


function cost=costlin(param, x,ydata, yerr, slope)
  yfit=param+slope*x;
  cost=(yfit-ydata)./yerr;
end



