function fitHill()
clc; close all
  % 'matlab' or 'octave'
  addpath('Regression')
 % include_optimisation_pkg('octave');
  include_optimisation_pkg()
  %===========================================
  % IMPORTDATA
  delim=' ';
  Nheader=1;
  data_units='M'
  %data=importdata('231208_SPR_S=1_3reps.txt', ' ', Nheader);
  
  data=importdata('Data/Experiments/221005_chlorella_R_chlorella_P.txt', ' ', Nheader);
  %Kd= 1.713100e-04 +/- 1.241107e-05
  %A = 1.114932e+02 +/- 9.279563e+00
  %B = 2.061387e+03 +/- 6.306226e+01
  %data=importdata('221006_Chlorella_R_Chlorella_2RBM.txt', ' ', Nheader);
   % RESULTS:
   %Kd= 1.323820e-06 +/- 7.711035e-08
   %A = 3.300167e+01 +/- 1.452209e+01
   %B = 1.617425e+03 +/- 2.195688e+01
  try data=data.data; end
  
  % Remove nans
  conc=data(:,1);
  if data_units=='M'
    conc=conc*1e6; % muM
  else 
    error('unexpected data_units')
  end
 % ydat=(data(:,2)+data(:,3)+data(:,4))/3;
  ydat=(data(:,2)+data(:,3)*0+data(:,4))/2
  Ndata=length(ydat);
  for i=1:Ndata
    ind=Ndata+1-i;
    if isnan(conc(ind)) || isnan(ydat(ind)) 
      conc(ind)=[];
      ydat(ind)=[];
    end
  end
  %===========================================

  %===========================================
  % FIT
  options=optimset('Display','off');
  param0=[mean(conc),0,max(ydat)];
  [param, resnorm, residual, qqq1, qqq2, qqq3, jacobian]=lsqnonlin(@(param)cost_hill(param,conc,ydat),param0,[],[],options);
  
  chisquare= resnorm; 
  Npar = 2;                              % Number of fit parameters
  dof  = length(ydat) - Npar;            % Degrees of freedom
p=chi2cdf(chisquare, dof);
  C          = inv(full(jacobian)'*full(jacobian));
  covarpar   = chisquare/dof*C;            % Variance-covariance matrix
  param_std  = sqrt(diag(covarpar))';    % Standard deviation (STD)

  corr_mat = C./sqrt(diag(C)*diag(C)');  % Correlation matrix 

  Rsquared=1-resnorm/((ydat-mean(ydat))'*(ydat-mean(ydat)));
  %===========================================
  
  
  %===========================================
  fprintf('Rsquared=%f\n',Rsquared);
  fprintf('Kd= %e +/- %e micromolar\n', param(1), param_std(1));
  fprintf('A = %e +/- %e\n', param(2), param_std(2));
  fprintf('B = %e +/- %e\n', param(3), param_std(3));
  
  conc_fit=10.^linspace(log10(min(conc(:)*0.1)),log10(max(conc(:)*10)),100);
  yfit=cost_hill(param,conc_fit,0);
  figure 
  plot(log10(conc),ydat, '.g', 'MarkerSize', 15); hold on
  plot(log10(conc_fit),yfit, 'r');
end


function y=cost_hill( param, conc, data )
  Kd=param(1);
  A=param(2); % offset
  B=param(3);
  y=A+B*conc./(conc+Kd) - data;
end

