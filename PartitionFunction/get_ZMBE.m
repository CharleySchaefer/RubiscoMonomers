% Partition sum ZMBE is a function of chemical potential muL of linker
% Ebind>0 is attractive binding energy
function ZMBE = get_ZMBE(muL, Ebind, Emisc, ZMB, M_all, B_all)
  % MISC: #SPACERS
%  ZMBE=ZMB.*exp( Ebind.*B_all + M_all.*(muL) + Emisc*(B_all-M_all) );
  % MISC: #MOLECULES
%  ZMBE=ZMB.*exp( Ebind.*B_all + M_all.*(muL) + Emisc*(M_all) );
  ZMBE=ZMB.*exp( Ebind.*B_all + M_all.*(muL)  );
end
