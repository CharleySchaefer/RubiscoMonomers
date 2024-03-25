function STATS=get_fit_stats(param, yfit, ydata, yerr,jacobian)
  STATS.yresidual=yfit-ydata;
  STATS.resnorm=sum( (STATS.yresidual./yerr).^2 );
  STATS.chisquare= STATS.resnorm; 
  STATS.Npar = length(param);                              % Number of fit parameters
  STATS.dof  = length(ydata) - STATS.Npar;            % Degrees of freedom
  STATS.p=chi2cdf(STATS.chisquare, STATS.dof);
  STATS.Cinv          = inv(full(jacobian)'*full(jacobian));
  STATS.covarpar   = STATS.chisquare/STATS.dof*STATS.Cinv;            % Variance-covariance matrix
  
  % CoVarPar = Cinv*chisquare/dof <--> chisquare = C * CoVarPar
  
  STATS.param_std  = sqrt(diag(STATS.covarpar))';    % Standard deviation (STD)
  STATS.corr_mat = STATS.Cinv./sqrt(diag(STATS.Cinv)*diag(STATS.Cinv)');  % Correlation matrix 
  STATS.Rsquared=1-sum(STATS.yresidual.^2)/(sum( (ydata-mean(ydata)).^2 )); %M_data-mean(M_data)
end

% Hessian = d^2 ChiSquare / d par^2
