function [LatticeCoor, LatticeDistances] = Lattice_Rubisco(coor, angles)
  
  PI_BY_2=pi/2;
  R=6.7; % Rubisco diameter in nm
 
  
  lattice_mode='dimer' ; %  'dimer', 'hpc', 'bcc'
  
  % Centre of mass
  %coor=get_coor_dimer(rr);
  
  % Rubisco parameters
  r10=R*[ 1; 1; 1]/sqrt(3);
  r20=R*[ 1;-1; 1]/sqrt(3);
  r30=R*[-1;-1; 1]/sqrt(3);
  r40=R*[-1; 1; 1]/sqrt(3);
  r50=R*[ 1; 1;-1]/sqrt(3);
  r60=R*[ 1;-1;-1]/sqrt(3);
  r70=R*[-1;-1;-1]/sqrt(3);
  r80=R*[-1; 1;-1]/sqrt(3);
  rall0=[r10,r20,r30,r40,r50,r60,r70,r80];

  % Rubisco variables
  [~, Nru]=size(coor);
  Rubisco=cell(1,Nru);
  for ind=1:Nru
    Rubisco{ind}.Rcm=coor(:,ind); %[ 0.0; 0.0; 0.0]; % centre of mass
  end
  
  % Rotate

  
  % Get random orientations
  for i=1:Nru
     % Orientation angles
    Rubisco{i}.a=angles(1,i);
    Rubisco{i}.b=angles(2,i);
    Rubisco{i}.c=angles(3,i);
    % Get coordinates of binding sites
    Rsites=get_site_coordinates(rall0,Rubisco{i}.Rcm,...
                                      Rubisco{i}.a,...
                                      Rubisco{i}.b,...
                                      Rubisco{i}.c );
    Rubisco{i}.Rsites=Rsites;
  end
  
  % Get intersite distances
  Nsites=Nru*8; 
  LatticeDistances=zeros(Nsites,Nsites);
  LatticeSites=zeros(3,Nsites);
  % Intramolecular distances (independent of orientation)
  [LatticeCoordinates, LatticeDistances_single_cube]=Lattice_Cube(R);
  for i=1:Nru
    LatticeDistances( ((i-1)*8+[1:8]) , ((i-1)*8+[1:8]) )=LatticeDistances_single_cube;
  end
  % Intermolecular distances
  for i=1:Nru
    for j=i+1:Nru
      for k=1:8
        site1=(i-1)*8+k;
        coor1=Rubisco{i}.Rsites(:,k);
        for l=1:8
          site2=(j-1)*8+l;
          coor2=Rubisco{j}.Rsites(:,l);
          x2=Rubisco{j}.Rsites(1);
          y2=Rubisco{j}.Rsites(2);
          z2=Rubisco{j}.Rsites(3);
          distance=sqrt( sum((coor1-coor2).^2) );
          LatticeDistances(site1, site2)=distance;
          LatticeDistances(site2, site1)=distance;
        end
      end
    end
  end
  LatticeDistances;
  LatticeCoor=zeros(3,Nru*8);
  for i=1:Nru
    for k=1:8
      site1=(i-1)*8+k;
      LatticeCoor(:,site1)=Rubisco{i}.Rsites(:,k);
    end
  end
end
