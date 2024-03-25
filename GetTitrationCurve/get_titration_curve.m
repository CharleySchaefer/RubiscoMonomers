% Ebind>0 is attractive energy
% Kd here is Kd0; where Kd=Kd0*exp(Ebind)
function [ Mmean, Bmean, M2mean,  B2mean,CL_by_Kd, f]= ... 
  get_titration_curve(CL0_by_Kd, CR0_by_Kd, ...
                      Ebind, Emisc, B_all, M_all, ZMB)
  if size(CL0_by_Kd)~=[1 1]
    error('CL0_by_Kd needs to be a scalar\n');
  end

  if CR0_by_Kd>0
    
    function CL_tot=_get_CL_tot(CL_by_Kd, CR0_by_Kd, Ebind, Emisc, B_all, M_all, ZMB)
      muL=log(CL_by_Kd); 
      ZMBE = get_ZMBE(muL, Ebind, Emisc, ZMB, M_all, B_all);
      %ZMBE = ZMB.*(CL_by_Kd).^M_all.*exp((B_all-M_all)*Ebind);
      Mmean=sum(     M_all.*ZMBE)/sum(ZMBE);
      CL_tot=CL_by_Kd + CR0_by_Kd*Mmean;  
    end
  
    CL_by_Kd=1.0*CL0_by_Kd; % Initial value
    CL_tot=2*CL0_by_Kd;     % Also initial value
    while CL_tot>CL0_by_Kd
      CL_by_Kd=0.5*CL_by_Kd;
      CL_tot=_get_CL_tot(CL_by_Kd, CR0_by_Kd, Ebind, Emisc, B_all, M_all, ZMB);
    end
    CL_by_Kd=fzero(@(CL_by_Kd)(_get_CL_tot( ...
            CL_by_Kd, CR0_by_Kd, Ebind, Emisc, B_all, M_all, ZMB)...
            - CL0_by_Kd), [CL_by_Kd, 2*CL_by_Kd]); 
  else
    CL_by_Kd=CL0_by_Kd;
  end
    muL=log(CL_by_Kd);
    ZMBE = get_ZMBE(muL, Ebind, Emisc, ZMB, M_all, B_all);
    Z1=sum(ZMBE);
    f=sum(     (M_all==0).*ZMBE)/Z1;
    Mmean=sum(      M_all.*ZMBE)/Z1;
    M2mean=sum(     M_all.^2.*ZMBE)/Z1;
    Bmean=sum(     B_all.*ZMBE)/Z1;
    B2mean=sum(     B_all.^2.*ZMBE)/Z1;

end


% Partition sum ZMBE is a function of chemical potential muL of linker
% Ebind>0 is attractive binding energy
%function ZMBE = get_ZMBE(muL, Ebind, Emisc, ZMB, M_all, B_all)
  % MISC: #SPACERS
%  ZMBE=ZMB.*exp( Ebind.*B_all + M_all.*(muL) + Emisc*(B_all-M_all) );
  % MISC: #MOLECULES
%  ZMBE=ZMB.*exp( Ebind.*B_all + M_all.*(muL) + Emisc*(M_all) );
%  ZMBE=ZMB.*exp( Ebind.*B_all + M_all.*(muL)  );
%end
