function demo_lin_regression()
  % Charley Schaefer, University of York 2021
  clc; close all;
  %--------------------
  % USER INPUT
  fname='testdata.txt';
  delimiter=' ';
  Nheader=1;
  mprog='octave'; % 'matlab' or 'octave'
  include_errorbars=1;
  %--------------------

  % IMPORT DATA
  data=importdata(fname, delimiter, Nheader);
  try data=data.data;
  end
  xdat=data(:,1);
  ydat=data(:,2);
  if(include_errorbars)
    yerr=data(:,3);
  else
    yerr=0*data(:,2);
  end

  % ANALYSE
  include_optimisation_pkg(mprog);
  [param, param_std, Rsquared, chisquare] = LinearRegression(xdat, ydat, yerr);
  fprintf('Rsquared: %f \n', Rsquared)
  fprintf('chisquare: %f \n', chisquare)
  fprintf('offset: %e +/- %e\n', param(1), param_std(2))
  fprintf('slope:  %e +/- %e\n', param(2), param_std(2))

  figure
  errorbar(xdat, ydat, yerr, '.k'); hold on
  plot (xdat, xdat*param(2) + param(1), 'r')
  

end
