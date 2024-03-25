% ZM1
function [Erow ZM]=get_ZM1_from_ZMB_file(pth, ZS, lK, varargin)


  Nsites=8;  % TODO: read Nsites from ZMB file
  [B1_data, M1_data, Z1_data]=import_ZMB(pth, ZS, lK);
  
    
  
  %-------------------------------------------------
  % Calculate ZM
  NE=100;
  Erow=linspace(0,20,NE);
  ZM=zeros(NE,Nsites);
  Bmean=zeros(NE,Nsites);
  
  for M=1:Nsites
    indices=find(M1_data==M);
    Brow=B1_data(indices);
    Zrow=Z1_data(indices);
    
    
    for i=1:NE
      ZM(i,M)=sum( Zrow.*exp(Brow*Erow(i)));
      Bmean(i,M)=sum( Brow.*Zrow.*exp(Brow*Erow(i)))/ZM(i,M);
    end
  end
  %-------------------------------------------------
  
  ifp=fopen(sprintf('ZM1_%d_%.2f.out',ZS,lK), 'w');
  for i=1:NE
    fprintf(ifp,'%12e ', Erow(i));
    for M=1:Nsites
      fprintf(ifp,'%12e ', -log(ZM(i,M)));
    end
    fprintf(ifp,'\n');
  end
  fclose(ifp);
  ifp=fopen(sprintf('B1_%d_%.2f.out',ZS,lK), 'w');
  for i=1:NE
    fprintf(ifp,'%12e ', Erow(i));
    for M=1:Nsites
      fprintf(ifp,'%12e ', Bmean(i,M));
    end
    fprintf(ifp,'\n');
  end
  fclose(ifp);

end
