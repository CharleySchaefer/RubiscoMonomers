function main()
  
  clc; close all;
  isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
  if ~isOctave
    warning('Potential compatibility options - were developed using Octave rather than matlab');
  end
  addpath('LatticeModels', 'PolymerModels', 'PartitionFunction', 'GetTitrationCurve');
  fprintf('==========\n');
  fprintf('YP3 Self Assembly - Charley Schaefer 2023\n');
  fprintf('==========\n');

%==============================================================
  % USER SETTINGS
%==============================================================
  
  %-------------------------
  % PARTITION FUNCTION
  PartitionFunction.do_calculate=1;
    PartitionFunction.Nsamples     =5000;
    PartitionFunction.tolerance_SEM=0.01;
    PartitionFunction.Lp_row=[0.76 0.88 1.00]; % 0.85 0.95 1.25] % 0.5 0.75 0.89 1 1.5 2 ];  % Kuhn length in FJC
                                      % Persistence length in WLC 
  % Lattice model  'LatticeCube'
  Rub_Radius=6.8; % 6.8 -- 7.8 includes the size of the stickers (radius=1 nm)
  Rub_Angle=45;
  LatticeModel='LatticeCube';                                     
                                     
  % Sequence
  SequenceModel = 'RegularSequence'; % 'EPYC1_5RBM' | 'RegularSequence'
    ZS=2;             % Specific to 'RegularSequence'
    SpacerLength=50;  % Specific to 'RegularSequence'
  Polymer_sequence=get_sequence(SequenceModel, ...
                                   SpacerLength, ZS);
      
  % Spacer properties                        
  PolymerModel.Type='FJC'; %'FreelyJointedChain' | 'WormLikeChain' | 'FENE'; 
    PolymerModel.k=0.48;      % Specific to FENE - spring constant in [1/nm^2]
    PolymerModel.R0=19;       % Specific to FENE - contour length in [nm]
  PolymerModel.beta=1.0;    % Specific to FJC dimensionless [-]
  PolymerModel.b=0.36;      % Amino acid step size [nm]
  %PolymerModel.b=0.317;      % Amino acid step size [nm]
       
  %-------------------------               
  % PROBABILITY DENSITIES  
  do_calc_ProbabilityDensities=0; 
    Lp_row=[0.88 ] ;       
    Emin=-5;
    Emax=30;
    NE=200; 
    
  %-------------------------
  % LINKER BINDING CURVES
  %   May be compared to Surface Plasmon Resonance
  %                   or Slimfield Spectroscopy
  do_calc_TitrationCurves=0;
    KD=414; % Dissociation constant of single sticker in microMolar
    KD=130; % Dissociation constant of single sticker in microMolar
    CR0=0.005; % Total Rubisco concentration in micromolar
    Emodel='PowerLaw'; % Constant | PowerLaw
    E0=11.9;
      pow=-0.55;       % only used for Emodel='PowerLaw'
      pow=-0.35;       % only used for Emodel='PowerLaw'
    CLmin=KD*1e-8;
    CLmax=KD*1e3;
    NCL=100;
    
    function E=get_E(Emodel, E0, lK, pow)
      switch Emodel
        case 'Constant'
          E=E0;
        case 'PowerLaw'
          E=E0*lK**pow;
      end
    end
    
  %-------------------------
  % LINKER DEPLETION CURVES
  %   May be compared to Fluorescence Correlation Spectroscopy
  LinkerDepletion.do_calculation=0;
    LinkerDepletion.Ebind=11.8;   % kT
    LinkerDepletion.Lp=    0.88;  % nm 
    LinkerDepletion.KD=414;       % in muM
    LinkerDepletion.CL= ...
      [1e-2 1e-1 1 10]; % [L] in muM
    LinkerDepletion.CR=10.^linspace(-6,3,100);  % [R] in muM
  
%==============================================================
  % END USER SETTINGS 
%==============================================================                  

  
  
  LinkerTag=sprintf('ZS%d_Slength%d', ZS, SpacerLength);
  LinkerTag=sprintf('ZS%d', ZS);
  switch LatticeModel
    case 'RubiscoSphere';
      LatticeType=sprintf('RubiscoSphere')
      dname=sprintf('Data/RubiscoSphere/%s_beta%06.2f', LatticeType, PolymerModel.beta);
      LinkerTag=sprintf('ZS%d_R%3.1f_A%03d_k%.2f', ZS,Rub_Radius,Rub_Angle,PolymerModel.k);
    case 'LatticeCube';
      LatticeType='LatticeCube';
      dname=strcat('Data/', LatticeType);
   
  end
  mkdir(dname)
  
  
  
  
  
  
%==============================================================
  % GET ZMB PARTITION FUNCTION 
%==============================================================  
  fprintf('Importing all ZMB files for LatticeModel=%s and with ZS=%d\n', LatticeModel, ZS);  
  if  strcmp(SequenceModel, 'RegularSequence')
          LinkerTag=sprintf('ZS%d', ZS) 
        elseif strcmp(SequenceModel, 'EPYC1_5RBM')
          LinkerTag=sprintf('%s', 'EPYC1_5RBM')  
        end
  try [Brow, Mrow, ZMB_all, lK_all] = ...
       import_ZMB(LatticeModel, sprintf('ZMB_%s_%s', PolymerModel.Type, LinkerTag), 'all-lk'); 
     logZMB_all=log(ZMB_all);
     
  catch
       warning('No files found.')
  end 
  if PartitionFunction.do_calculate==1
    
    for NLPind=1:length(PartitionFunction.Lp_row);
      PolymerModel.Lp=PartitionFunction.Lp_row(NLPind);
    
      if strcmp(LatticeType, 'RubiscoSphere')
        param=[Rub_Radius,Rub_Angle]
        LatticeDistances=main_LatticeModel(LatticeModel,param)
      elseif strcmp(LatticeType, 'PatchyParticle')
        LatticeDistances=main_LatticeModel(LatticeType,fname_coor);
      
      else
      
        param='dummy';
        LatticeDistances=main_LatticeModel(LatticeType,param);  
        if  strcmp(SequenceModel, 'RegularSequence')
          LinkerTag=sprintf('ZS%d', ZS) 
        elseif strcmp(SequenceModel, 'EPYC1_5RBM');
          LinkerTag=sprintf('%s', 'EPYC1_5RBM');  
        end
      end
    
      
      
      fname_ZMB=sprintf('%s/ZMB_%s_%s_%.2f.out', dname,...     
                 PolymerModel.Type, LinkerTag,PolymerModel.Lp)
      tic
      calc_ZMB(LatticeDistances, Polymer_sequence,...
            PolymerModel,...
            PartitionFunction.Nsamples,...  
            PartitionFunction.tolerance_SEM,...
            fname_ZMB, 1); 
      toc
      fprintf('ZMB written to %s --re-import ZMB files\n', fname_ZMB);
    end
    [Brow, Mrow, ZMB_all, lK_all] = ...
       import_ZMB(LatticeModel, sprintf('ZMB_%s_%s', PolymerModel.Type, LinkerTag), 'all-lk'); 
     logZMB_all=log(ZMB_all);
    
  end 
  fprintf('ZMB data available for Lp in the range [%f, %f] nm\n\n', min(lK_all), max(lK_all));
  
  
  
  
  
%==============================================================
  % GET PROBABILITY DENSITIES
%==============================================================    
  if do_calc_ProbabilityDensities==1
    fprintf('Calculating Probability Density ...\n');
    for NLPind=1:length(Lp_row);
      PolymerModel.Lp=Lp_row(NLPind);
      ZMB=( interp1(lK_all, (logZMB_all), PolymerModel.Lp, 'spline' ) );
      ZMB=exp(ZMB');
  
      fprintf('  ... for Lp=%f\n', PolymerModel.Lp);
    %erow=13*PolymerModel.Lp**(-0.47)
    erow=linspace(Emin,Emax,NE);
    for M=1:max(Mrow)
      brow  = Brow((Mrow==M));
      zrow  = ZMB((Mrow==M));
    
      fname=sprintf('%s/prow_%s_%s_%.2f_%d.out', dname, PolymerModel.Type, LinkerTag, PolymerModel.Lp, M);
      ifp=fopen(fname, 'w');
        fprintf(ifp, '#E        ');
        for j=1:length(brow)
          fprintf(ifp, '%12d ', brow(j));
        end
        fprintf(ifp, '\n');
      for i=1:length(erow)
        ebind=erow(i);
        zerow = zrow.*exp(ebind*brow);
        Prow  = zerow/sum(zerow);
        fprintf(ifp, '%12e ', ebind);
        for j=1:length(brow)
          fprintf(ifp, '%12e ', Prow(j));
        end
        fprintf(ifp, '\n');
      end
      fclose(ifp);
     end
    end
  end % Lp loop
  
%==============================================================
  % GET TITRATION CURVES 
%==============================================================
  Emisc=0;
  if do_calc_TitrationCurves==1
    Emisc=0; % PARAMETER FOR TESTING -- unused 
    
    fprintf('Calculating Titration Curve ... \n');
    for NLPind=1:length(Lp_row);
      PolymerModel.Lp=Lp_row(NLPind);
      fprintf(' ... for Lp=%f\n',PolymerModel.Lp);
      ZMB=( interp1(lK_all, (logZMB_all), PolymerModel.Lp, 'spline' ) );
      ZMB=exp(ZMB');
    
      fname_titration=sprintf('%s/titration_%s_%s_%.2f.out', dname,...
        PolymerModel.Type, LinkerTag, PolymerModel.Lp);
  
      ifp=fopen(fname_titration, 'w');
      EBind=get_E(Emodel, E0, PolymerModel.Lp, pow);
      KD0=KD*exp(EBind); % Units of concentration [muM]
      CLrow=exp(linspace(log(CLmin),log(CLmax),NCL));
      CL0_by_KD=CLrow/KD0;
      CR0_by_Kd=CR0/KD0;
  
  
      fprintf(ifp, "#Data: %12s\n", fname_titration);
      fprintf(ifp, "#%12s %12s %12s %12s %12s %12s %12s\n", 'E', 'mu', 'f', '<N>', '<N2>', '<B>', '<B2>');
    
      for i=1:length(CL0_by_KD)
      
        [ Mmean(i), Bmean(i), M2mean(i), B2mean(i), CL_by_Kd(i), f(i)]=  ...
         get_titration_curve(CL0_by_KD(i), CR0_by_Kd, EBind, Emisc, Brow, Mrow, ZMB);
        mu=log(CL_by_Kd(i));
        fprintf(ifp, "%12f %12e %12e %12e %12e %12e %12e %12e\n", EBind, mu, f(i), Mmean(i), M2mean(i), Bmean(i), B2mean(i),1); 
          % 1 used to be log(sum(ZMBE))
      end
      if ~exist("h_fig_titration", "var") 
        h_fig_titration=figure;
      else
        figure(h_fig_titration);
      end
      subplot(2,1,1)
      plot(log10(CLrow),Mmean); hold on;
 % errorbar(log10(CLrow),Mmean, sqrt(M2mean- Mmean.^2)); hold on;
      plot(log10(CLrow),8*CLrow./(KD+CLrow)); hold on;
      title('Linkers bind as they are titrated to Rubisco');
      xlabel('log_{10} concentration ({\mu}M)')
      ylabel('<M>')
      subplot(2,1,2)
      plot(log10(CLrow),Bmean); hold on;
%  errorbar(log10(CLrow),Bmean, sqrt(B2mean- Bmean.^2)); hold on;
      xlabel('log_{10} concentration ({\mu}M)')
      ylabel('<B>')
  
      fclose(ifp);
 
    end % Lp loop
  end
  
  
%==============================================================
  % GET DEPLETION CURVES 
%==============================================================
  if LinkerDepletion.do_calculation==1
    fprintf('Calculating Depletion Curves ... \n');
    
    
      
    
  
  
  KD=LinkerDepletion.KD;
  KD0=KD*exp(EBind); % Units of concentration
  CL0_by_Kd=LinkerDepletion.CL/KD0;
  CL_by_Kd=zeros(size(CL0_by_Kd)); % initialise
  CR0_by_Kd=LinkerDepletion.CR/KD0;
  EBind=LinkerDepletion.Ebind;
  
  ZMB=( interp1(lK_all, (logZMB_all), LinkerDepletion.Lp, 'spline' ) );
  ZMB=exp(ZMB');
  
  ifp=fopen(sprintf('%s/LinkerDepletion_lK%.2f_E%.2f.out', dname, LinkerDepletion.Lp, EBind), 'w');
  fprintf(ifp, '#KD=    %e [muM]\n', KD);
  fprintf(ifp, '#Ebind= %e [kT]\n', EBind);
  fprintf(ifp, '%12s %12s %12s\n', 'CL0[muM]', 'CR0[muM]', 'CL[muM]');
  
  figure
  for i=1:length(CL0_by_Kd)
    fprintf('  ... for [L_0]=%f [muM]\n', LinkerDepletion.CL(i)); % This is the actual Kd, rather than Kd0
    for j=1:length(CR0_by_Kd)
  [ Mmean, Bmean, M2mean,  B2mean,cL_by_Kd, f]= ... 
  get_titration_curve(CL0_by_Kd(i), CR0_by_Kd(j), ...
                      EBind, Emisc, Brow, Mrow, ZMB);
       CL_by_Kd(j)=cL_by_Kd;
       fprintf(ifp, '%12e %12e %12e\n', ...
                    CL0_by_Kd(i), CR0_by_Kd(j), CL_by_Kd(j));
    end
    plot(log10(CR0_by_Kd/CL0_by_Kd(i)), CL_by_Kd/CL0_by_Kd(i)); hold on;
    title('Linkers deplete as Rubisco is titrated');
    xlabel('[R_{0}]/[L_{0}]')
    ylabel('[{L}]/[L_{0}]')
  end
  fclose(ifp);
  
  
  end % END LinkerDepletion
  
  
  
%==============================================================
  % TEST NEW FEATURES 
%==============================================================  
  do_curve_fitting=1;
  if do_curve_fitting==1
      fprintf('Testing Mode!\n')';
      addpath('Regression');
      include_optimisation_pkg();
      fit_options = optimset(...   
            'MaxIter',1000,...
            'Display','off',...
            'MaxFunEvals',100000,...
            'TolX',1e-10,...
            'TolFun',1e-10);%,...
            
      %========================================
      % USER INPUT
      DataZS2.fname='Data/Experiments/231208_SPR_S=2_3reps.txt';
      DataZS2.Nheader=1;
      DataZS2.delim=' ';
      DataZS2.concentration_units='muM';
      DataZS2.ZS=2;
      DataZS2.CR0=0.005;
      DataZS2.param0=[ 1, 0.89, 400]; % Ebind, lK, normfac
            
      DataZS3.fname='Data/Experiments/Slimfield_S=3.txt';
      DataZS3.Nheader=1;
      DataZS3.delim=' ';
      DataZS3.concentration_units='nM';
      DataZS3.ZS=3;
      DataZS3.CR0=0.005;
      DataZS3.param0=[12.5, 0.89]; % Ebind, lK
            
      DataZS5.fname='Data/Experiments/Slimfield_S=5.txt';
      DataZS5.Nheader=1;
      DataZS5.delim=' ';
      DataZS5.concentration_units='nM';
      DataZS5.ZS=5;
      DataZS5.CR0=0.005;
      DataZS5.param0=[13.5, 0.89];  % Ebind, lK
      
      
      FitData.select=[0 0 1];
      % END USER INPUT
      %========================================
      
      % IMPORT DATA
      NDATA=length(FitData.select);
      for i=1:NDATA;
        ind=NDATA+1-i;
        if FitData.select(ind)~=1
          AllData(ind)=[];
          continue
        end
          Data = AllData{ind};
          
          % IMPORT EXPERIMENTAL DATA
          fprintf('Importing %s\n', Data.fname);
          
          data=importdata(Data.fname, Data.delim, Data.Nheader);
          try data=data.data; end
          [Nrows,Ncols]=size(data);
        
          % Filter datapoints
          for j=1:Nrows
            ind2=Nrows+1-j;
            if data(ind2,1)<=0 || isnan(data(ind2,1)) % remove concentrations smaller or equal to zero
              data(ind2,:)=[];
            end
          end
        
          % Set units to muM
          switch Data.concentration_units
            case 'M'
              data(:,1)=data(:,1)*1e6; 
            case 'mM'
              data(:,1)=data(:,1)*1e3; 
            case 'muM'
              ; % do nothing
            case 'nM'
              data(:,1)=data(:,1)*0.001; 
            otherwise
              error('Concentration units not recognised.\n');
          end
          data(:,3)=(data(:,4)-data(:,3))/2; % UNSET ERRORS;
          Data.data=data;
          
          % IMPORT PARTITION FUNCTION
          fprintf('Importing all ZMB files with ZS=%d\n', Data.ZS);  
          [Brow, Mrow, ZMB_all, lK_all] = ...
            import_ZMB(LatticeModel, sprintf('ZMB_%s_%s', PolymerModel.Type, LinkerTag), 'all-lk'); % Expect
          Data.Brow=Brow;
          Data.Mrow=Mrow;
          Data.logZMB_all=log(ZMB_all);  
          Data.lK_all=lK_all;  
          
  
  
          % STORE DATA
          AllData(ind)=Data;
      end
      
      % INDIVIDUAL FIT
      figure
      for i=1:length(AllData);
        Data=AllData{i};
        data=Data.data;
        plot(log10(data(:,1)), data(:,2), '.k', 'MarkerSize', 15);
        xlabel('log10 concentration (muM)')
      
      
        param0=Data.param0;
        paramL=[ 4, min(Data.lK_all)];
        paramU=[40, max(Data.lK_all)];
        if length(param0)>2
          paramL(3)= 0.1*param0(3);
          paramU(3)=10.0*param0(3);
        end
      
      
        CL0_by_Kd = Data.data(:,1);
        CR0_by_Kd=0.0;
        M_data=Data.data(:,2);
        M_err=Data.data(:,3);
       % M_err=1;
        [param, resnorm, residual, qqq1, qqq2, qqq3, jacobian]=...
          lsqnonlin(@(param)cost_fit4(param, Emisc, ... 
                               Data.Brow, Data.Mrow, Data.lK_all, Data.logZMB_all, ...
                               CL0_by_Kd, CR0_by_Kd, M_data, M_err),...
                               param0, paramL, paramU, fit_options);
    
    
        % ERROR ANALYSIS
        if length(param)>2
          NormFac=param(3);
        else
          NormFac=1;
        end
        M_data=M_data/NormFac;
        M_fit=M_err.*residual/NormFac+M_data;
        jacobian=jacobian/NormFac;
        STATS=get_fit_stats(param, M_fit, M_data, M_err,jacobian);
        
    
         % STORE RESULTS
         Data.Rsquared=STATS.Rsquared;
         Data.Ebind = [param(1) STATS.param_std(1)];
         Data.Lp    = [param(2) STATS.param_std(2)];
         if length(param)>2
           Data.NormFac =  [param(3) STATS.param_std(3)];
         else
           Data.NormFac = [1 , 0];
         end  
         AllData{i} = Data;
      end  % Done individual fit
    
    
     % REPORT RESULTS
    hdata=figure;
    for ind=1:length(AllData);
      Data=AllData{ind};
      
      fprintf('\nIndividual fit for ZS=%d\n', Data.ZS);
      fprintf('Rsquared = %f\n', Data.Rsquared);
      fprintf('Ebind   = %f +/- %f\n', Data.Ebind(1), Data.Ebind(2));
      fprintf('Lp      = %f +/- %f\n', Data.Lp(1), Data.Lp(2));
      fprintf('NormFac = %f +/- %f\n', Data.NormFac(1), Data.NormFac(2));
      data=Data.data;
      data(:,2)=data(:,2)/Data.NormFac(1);
      plot(log10(data(:,1)), data(:,2), '.k', 'MarkerSize', 15); ; hold on
      xlabel('log10 concentration (muM)')
      ylabel('<M>')
      
      EBind=Data.Ebind(1);
      Lp=Data.Lp(1);
      ZMB=( interp1(Data.lK_all, (Data.logZMB_all), Lp, 'spline' ) );
      ZMB=exp(ZMB');
    
      
      KD0=KD*exp(EBind); % Units of concentration [muM]
      CLrow=exp(linspace(log(CLmin),log(CLmax),NCL));
      CL0_by_KD=CLrow/KD0;
      CR0_by_Kd=CR0/KD0;
  
      
      for i=1:length(CL0_by_KD)
        [ Mmean(i), Bmean(i), M2mean(i), B2mean(i), CL_by_Kd(i), f(i)]=  ...
         get_titration_curve(CL0_by_KD(i), CR0_by_Kd, EBind, Emisc, Data.Brow, Data.Mrow, ZMB);
      end
      plot(log10(CL0_by_KD*KD0), Mmean);
      
      
      EBind=param(1);
      Lp=param(2);
      ZMB=( interp1(Data.lK_all, (Data.logZMB_all), Lp, 'spline' ) );
      ZMB=exp(ZMB');
    
      
      KD0=KD*exp(EBind); % Units of concentration [muM]
      CLrow=exp(linspace(log(CLmin),log(CLmax),NCL));
      CL0_by_KD=CLrow/KD0;
      CR0_by_Kd=CR0/KD0;
  
      
      for i=1:length(CL0_by_KD)
        [ Mmean(i), Bmean(i), M2mean(i), B2mean(i), CL_by_Kd(i), f(i)]=  ...
         get_titration_curve(CL0_by_KD(i), CR0_by_Kd, EBind, Emisc, Data.Brow, Data.Mrow, ZMB);
      end
      plot(log10(CL0_by_KD*KD0), Mmean, 'k');
      
    end
    
      % SIMULTANEOUS FIT
      [param, resnorm, residual, qqq1, qqq2, qqq3, jacobian]=...
        lsqnonlin(@(param)cost_fit_simultaneous(param, Emisc, KD, AllData), param0, paramL, paramU, fit_options);
      
        % ERROR ANALYSIS
        if length(param)>2
          NormFac=param(3);
        else
          NormFac=1;
        end
        M_data=[];M_err=[];
  for data_ind=1:length(AllData)
    Data=AllData{data_ind};
    M_data=[M_data ; Data.data(:,2)];
    M_err=[M_err ; Data.data(:,3)];
  end
  
        M_data=M_data/NormFac;
        M_fit=M_err.*residual/NormFac+M_data;
        M_err=M_err/NormFac;
        
        jacobian=jacobian/NormFac;
        STATS=get_fit_stats(param, M_fit, M_data, M_err,jacobian);
        
    fprintf('\nSimultaneous Fit:\n')
      fprintf('Rsquared = %f\n', STATS.Rsquared);
      fprintf('p        = %f\n', STATS.p);
      fprintf('corr        = %f\n', STATS.corr_mat(1,2));
      fprintf('Ebind   = %f +/- %f\n', param(1), STATS.param_std(1));
      fprintf('Lp      = %f +/- %f\n', param(2), STATS.param_std(2));
      %fprintf('NormFac = %f +/- %f\n', param(3), 0*Data.NormFac(2));
  
  hR2=figure;
  LPROW=linspace(0.36,2,50);
  
  param0=10;
  paramL=paramL(1);
  paramU=paramU(1);
  param0=[25, 700];
  paramL=[4, 70];
  paramU=[40, 7000];
  
  
  ifp=fopen('Data/FitResults/curve_fit.txt', 'w');
  %fprintf('');
  fprintf(ifp, '%12s %12s %12s %12s\n', '#Lp', 'Ebind', 'Ebinderr', 'Rsquared');
  for k=1:length(LPROW)
  
     [param, resnorm, residual, qqq1, qqq2, qqq3, jacobian]=...
    lsqnonlin(@(param)cost_fit_fixLK(param, LPROW(k),Emisc, KD, AllData), param0, paramL, paramU, fit_options);
    
        if length(param)>1
          NormFac=param(2)
        else
          NormFac=1;
        end
        M_data=[];
        for data_ind=1:length(AllData)
          Data=AllData{data_ind};
          M_data=[M_data ; Data.data(:,2)];
        end
        sum(residual(:).^2)
        M_data=M_data/NormFac;
        M_fit=M_err.*residual/NormFac+M_data;
        jacobian=jacobian/NormFac;
        STATS=get_fit_stats(param, M_fit, M_data, M_err,jacobian);
       %figure(hR2) 
       subplot(2,1,1)
    plot(LPROW(k), STATS.Rsquared, '.k', 'MarkerSize', 15); hold on;
    param0=[param];
    
      EBind=param(1);
      for data_ind=1:length(AllData)
        Data=AllData{data_ind};
      ZMB=( interp1(Data.lK_all, (Data.logZMB_all), LPROW(k), 'spline' ) );
      ZMB=exp(ZMB');
    
      
      KD0=KD*exp(EBind); % Units of concentration [muM]
      CLrow=exp(linspace(log(CLmin),log(CLmax),NCL));
      CL0_by_KD=CLrow/KD0;
      CR0_by_Kd=CR0/KD0;
  
      
      for i=1:length(CL0_by_KD)
        [ Mmean(i), Bmean(i), M2mean(i), B2mean(i), CL_by_Kd(i), f(i)]=  ...
         get_titration_curve(CL0_by_KD(i), CR0_by_Kd, EBind, Emisc, Data.Brow, Data.Mrow, ZMB);
      end
%      figure(hdata)
       subplot(2,1,2)
      plot(log10(Data.data(:,1)), (Data.data(:,2)/NormFac), '.k', 'MarkerSize', 12); hold on
      plot(log10(CL0_by_KD*KD0), Mmean); hold on
      end
    
    fprintf(ifp, '%12f %12f %12f %12f\n', LPROW(k), param(1), STATS.param_std(1), STATS.Rsquared);
    fprintf( '%12f %12f %12f %12f\n', LPROW(k), param(1), STATS.param_std(1), STATS.Rsquared);
  end
  fclose(ifp);
 % end
%  end
  
    
    
    
    
  end % Done testing mode
  
  
end % END OF MAIN



function cost=cost_fit4(param, Emisc, B_all, M_all, lKrow, logZMB_all,  CL0_by_Kd, CR0_by_Kd, M_data, M_err)
  Ebind=param(1);
  lK=param(2);
  if length(param)>2
    NormFac=param(3);
  else
    NormFac=1;
  end
  
  ZMB=( interp1(lKrow, (logZMB_all), lK, 'spline' ) );
  ZMB=exp(ZMB');
   
  M_fit=zeros(size(M_data));
  for i=1:length(CL0_by_Kd)
    CL0_by_Kd0 = CL0_by_Kd(i)*exp(-Ebind);
    [ M_fit(i), Bmean, M2mean,  B2mean,CL_by_Kd, f]= ... 
      get_titration_curve(CL0_by_Kd0, CR0_by_Kd, ...
                      Ebind, Emisc, B_all, M_all, ZMB);
  end

  cost=(NormFac*M_fit-M_data)./M_err;
end

