% KD - dissociation constant of single-sticker fragment
function cost=cost_fit_fixLK(param, lK, Emisc, KD, AllData)
  Ebind=param(1);
  KD0=KD*exp(Ebind); 
  %lK=param(2);
  if length(param)>1
    NormFac=param(2);
  else
    NormFac=1;
  end
  
  cost=[];
  for data_ind=1:length(AllData)
    Data=AllData{data_ind};
    B_all=Data.Brow;
    M_all=Data.Mrow;
    ZMB=( interp1(Data.lK_all, Data.logZMB_all, lK, 'spline' ) );
    ZMB=exp(ZMB');
    
    CL0_by_Kd=Data.data(:,1)/KD0;
    CR0_by_Kd=Data.CR0/KD0;
    M_data   =Data.data(:,2);
    M_err    =Data.data(:,3);
    M_fit=zeros(size(M_data));
  
    for i=1:length(CL0_by_Kd)
      [ M_fit(i), Bmean, M2mean,  B2mean,CL_by_Kd, f]= ... 
        get_titration_curve(CL0_by_Kd(i), CR0_by_Kd, ...
                      Ebind, Emisc, B_all, M_all, ZMB);
    end
    cost=[cost ; (NormFac*M_fit-M_data)./M_err;];
  end
end
