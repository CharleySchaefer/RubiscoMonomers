% Nsamples:       minimum number of samples
% tolerance_SEM:  tolerance for Standard error of Mean;
                  % algorithm takes extra samples to meet tolerance. 
function calc_ZMB(LatticeDistances, Polymer_sequence,PolymerModel, Nsamples, tolerance_SEM, fname_out, verbose)  
  LatticeDistances;
  [Nsites, Nsites]=size(LatticeDistances);
  % Polymer
  Zs=sum(Polymer_sequence==1);
    % Determine number of monomers between stickers
  Polymer_sticker_indices=find(Polymer_sequence==1);
  LinkerLength=zeros(Zs,Zs);
  for i=1:Zs-1
    for j=i+1:Zs
      LinkerLength(i,j)=Polymer_sticker_indices(j)-Polymer_sticker_indices(i)-1;
      LinkerLength(j,i)=LinkerLength(i,j);
    end
  end
  LinkerLength
  if verbose
  fprintf('     Chains with Zs=%d stickers will adsorb to a lattice with Nsites=%d.\n', Zs, Nsites);
  %=====================
  
  %=====================
  % Calculate partitions
  fprintf('2. Get partitions, and the number of sticker selections\n   and the number of binding permutations per partition.\n');
  end
  
  [partitions, col_select, col_bind, colM, colB]=calculate_partitions(Nsites, Zs);
  Npartitions=size(partitions,1);
  if verbose 
  fprintf('     Total number of microstates: %d\n', sum(partitions(:,col_select).*partitions(:,col_bind)./factorial(partitions(:,colM))));
  fprintf('     Total number of possible sticker selections: %d\n', sum(partitions(:,Zs+1)));
  fprintf('     Total number of integer partitions: %d\n', Npartitions);
  fprintf('     Total number of M,B partition functions to calculate: %d\n', Nsites *(Nsites+1)/2);
  %printf('     ');
  end
  % END: partitions are calculated
  %=====================
  
 % partitions
 
  
  Zconf=zeros(Nsites,Nsites); % Partition function
 
 
  ifp = fopen(fname_out, 'w');
  fprintf(ifp, '%4s %4s %12s %8s %12s %12s\n', 'B','M','Omega0', 'psiMB', 'ZMB', 'ZSEM');
  count=0;
  for B=1:Nsites
    for M=1:B
      if verbose
      fprintf('Progress: B=%d/%d; M=%d/%d; %.1f %%\n', B, Nsites, M, B, count*100.0/((Nsites+1)*Nsites/2));
      end
      count=count+1;
      % Get partition subset
      partitions_MB=partitions;
      for i=1:Npartitions % Sweep rows
        ind=Npartitions+1-i;
        if(partitions_MB(ind,colM)~=M ||partitions_MB(ind,colB)~=B )
          partitions_MB(ind,:)=[]; % Delete row
        end
      end
      if isempty(partitions_MB)
        ;
      else
      
      OmegaMB0=sum(partitions_MB(:,col_select).*partitions_MB(:,col_bind));
      
      
      Npartitions_MB=size(partitions_MB,1);
      Omega_select_MB=sum(partitions_MB(:,col_select));
      partition_selection_prob=partitions_MB(:,col_select)/Omega_select_MB;
      Pcumm=zeros(Npartitions_MB,1);
      Pcumm(1)=partition_selection_prob(1);
      for i=2:Npartitions_MB
        Pcumm(i)=Pcumm(i-1)+partition_selection_prob(i);
      end
      
      Zsum=0; ZROW=[];
      c1=0;
      c2=0;
      sample=0;  ZSEM=2*tolerance_SEM;
      
      while sample<2500 || ((sample<Nsamples) && (isnan(ZSEM) || (ZSEM > tolerance_SEM) ))
        sample=sample+1;
        
        % Sample microstate
        c1=c1+1;
        % Select partition
        rnd=rand();
        select_index=1;
        while Pcumm(select_index)<rnd % Speed can be improved using bisection method; only worthwhile if Npartitions_MB is large though.
          select_index=select_index+1;
        end
        selected_partition=partitions_MB(select_index,:);
        
        % Random permutation of sites
        site_indices=randperm(Nsites);
         
         
        % Random selection of stickers
        site_ind=0;
        b=1; MicrostateRejected=0;
        Ssum=0.0;
           % Generate microstate and calculate conformational entropy
        while b<=Zs && MicrostateRejected==0
        
          mb=selected_partition(b); % Number of molecules of which b stickers are bound
          if b==1  % Molecules with single sticker bound always possible, no linker conformational entropy.
            site_ind=site_ind+mb; % first bn sites are occupied
          elseif b>1 % Molecules with multiple stickers bound contribute linker conformational entropy
          
          for l=1:mb % Loop over all monomers with b stickers bound
            % Random select of b stickers
            tmp=randperm(Zs);
            stic_indices=sort(tmp(1:b)); % select first b stickers, and sort them
        
            % attempt to bind stickers to lattice
            for k=1:b-1 % If b stickers are bound, b-1 spacers are stretched.
              % Number of monomers in the linker
              Nlinker=LinkerLength( ...
                  stic_indices(k),stic_indices(k+1)  );
              linker_contour_length=PolymerModel.b*Nlinker;
              % Distance between lattice sites
              site_distance=LatticeDistances(site_indices(site_ind+k), site_indices(site_ind+k+1));
              if MicrostateRejected==1 || linker_contour_length<site_distance % chain too short to reach distance
                MicrostateRejected=1; S_by_kT=0;
                %break;
              else % Calculate entropy contribution
                if strcmp(PolymerModel.Type, 'FreelyJointedChain') || strcmp(PolymerModel.Type, 'FJC') 
                
                 S_by_kT=ChainEntropy_FJC(site_distance,PolymerModel.b,Nlinker,PolymerModel.Lp,PolymerModel.beta, 'fene');
                
                 elseif strcmp(PolymerModel.Type, 'WormLikeChain')  || strcmp(PolymerModel.Type, 'WLC')
                   S_by_kT=ChainEntropy_WLC(site_distance,PolymerModel.b,Nlinker, PolymerModel.Lp);
                
                 elseif strcmp(PolymerModel.Type, 'FENE')
                   S_by_kT=ChainEntropy_FENE(site_distance, PolymerModel.k, PolymerModel.R0);
                 
                 else
                   error('Unknown polymer model.');
                 end
                 Ssum=Ssum+S_by_kT;
              end
            end % end loop: all linkers of a single polymer
            site_ind=site_ind+b;
            end % end loop over all monomers with b stickers bound
          end % end if b>1
         b=b+1;
        end % end while loop over b
        if MicrostateRejected==0
          c2=c2+1;
          Zsum=Zsum+exp(-Ssum);
          ZROW=[ZROW, exp(-Ssum)];
          if sample>1
            ZSEM=sqrt(var( (ZROW))/(sample-1))/mean( (ZROW));
          end
        end
      end % sample loop
      
      psiMB=c2/c1;  % Fraction of accepted states
      OmegaMB=OmegaMB0*psiMB;
      % Expectation value of ZMB
      if c2==0
        exp_mean=0; ZSEM=0;
      else
        exp_mean=Zsum/c2;
        size(ZROW);
        mean(ZROW);
        if sample>1
        ZSEM=sqrt(var((ZROW))/(sample-1))/mean((ZROW));
        end
      end
      
      ZMB=exp_mean*OmegaMB;
      
      fprintf(ifp,'%4d %4d %12e %8f %12e %12e\n', B,M, OmegaMB0, psiMB, (ZMB), ZSEM);
      end
    end % end M loop
  end % end B loop
  fclose(ifp);
end


%#############################################
function [all_partitions, col_select, col_bind, colM, colB]=calculate_partitions(Nsites, Zs)

  all_partitions=[];  
  for B=1:Nsites  % B=number of bound stickers  
    partitions=integer_partitions(B,Zs);
    
    [Npartitions]=size(partitions,1);
    Nmolecules=sum(partitions(:,1:end), 2);
    
    % Calculate number of possible sticker selections per partition
    Omega_stic_MB=ones(Npartitions,1);
    for i=1:Npartitions
      for b=1:Zs
        mb=partitions(i,b);
        Omega_stic_MB(i)=Omega_stic_MB(i)*...
            (factorial(Zs)/(factorial(Zs-b)*factorial(b)))^mb/factorial(mb);
        
      end
    end
    Omega_site_MB=factorial(Nsites)/(factorial(Nsites-B));
    Omega_site_MB=Omega_site_MB*ones(Npartitions,1);


    
    partitions=[partitions,Omega_stic_MB,Omega_site_MB];
    
    % Sort partitions according to the number of molecules in each partition.
    %Nmolecules=sum(partitions(:,1:end-2), 2);
    Bcolumn=B*ones(Npartitions,1);
    partitions=[partitions, Nmolecules,Bcolumn ];
    partitions=sortrows(partitions,Zs+3); % sort based on Nmolecules column
     
    all_partitions=[all_partitions; partitions];
  end
  col_select=Zs+1;
  col_bind=Zs+2;
  colM=Zs+3; % column in partitions array with M values
  colB=Zs+4; % column in partitions array with B values
end
