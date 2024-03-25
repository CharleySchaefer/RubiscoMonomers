% [Nsites, 3] = size(LatticeCoordinates)
function LatticeDistances=PatchySphere_Coor2Dist(LatticeCoordinates)
  
  LatticeCoordinates=(LatticeCoordinates-mean(LatticeCoordinates));
  
  
  % Get distances
  Radii=sqrt(  LatticeCoordinates(:,1).^2 ...
             + LatticeCoordinates(:,2).^2 ...
             + LatticeCoordinates(:,3).^2 );
             
  Nsites=length(Radii);
  LatticeDistances=zeros(Nsites,Nsites);
  
  for i=1:Nsites-1
    Ri=Radii(i);
    veci=LatticeCoordinates(i,:);
    for j=i+1:Nsites
      Rj=Radii(j);
      vecj=LatticeCoordinates(j,:);
      
      theta=acos( dot(veci,vecj)/(Ri*Rj)  );
      dis=theta*( 0.5*(Ri+Rj) );
      LatticeDistances(i,j)=dis;
      LatticeDistances(j,i)=dis;
    end
  end
  
end
