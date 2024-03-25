% Cube corners: 8 sites
% R: edge distance
function [LatticeCoor, LatticeDistances]=Lattice_Cube(Radius)

  r10=Radius*[ 1; 1; 1]/sqrt(3);  % Coordinates of binding sites
  r20=Radius*[ 1;-1; 1]/sqrt(3);
  r30=Radius*[-1;-1; 1]/sqrt(3);
  r40=Radius*[-1; 1; 1]/sqrt(3);
  r50=Radius*[ 1; 1;-1]/sqrt(3);
  r60=Radius*[ 1;-1;-1]/sqrt(3);
  r70=Radius*[-1;-1;-1]/sqrt(3);
  r80=Radius*[-1; 1;-1]/sqrt(3);
  LatticeCoor=[r10,r20,r30,r40,r50,r60,r70,r80];


  R=Radius*sqrt(4/3);
  LatticeDistances=zeros(8,8);
  % Nearest Neighbours
    % top plane
  LatticeDistances(1,2)=R; LatticeDistances(2,1)=R;
  LatticeDistances(2,3)=R; LatticeDistances(3,2)=R;
  LatticeDistances(3,4)=R; LatticeDistances(4,3)=R;
  LatticeDistances(4,1)=R; LatticeDistances(1,4)=R;
    % bottom plane
  LatticeDistances(5,6)=R; LatticeDistances(6,5)=R;
  LatticeDistances(6,7)=R; LatticeDistances(7,6)=R;
  LatticeDistances(7,8)=R; LatticeDistances(8,7)=R;
  LatticeDistances(8,5)=R; LatticeDistances(5,8)=R;
    % Edges top-bottom
  LatticeDistances(1,5)=R; LatticeDistances(5,1)=R;
  LatticeDistances(2,6)=R; LatticeDistances(6,2)=R;
  LatticeDistances(3,7)=R; LatticeDistances(7,3)=R;
  LatticeDistances(4,8)=R; LatticeDistances(8,4)=R;
  
  % Next-Nearest Neighbours
    % top plane
  LatticeDistances(1,3)=R*sqrt(2); LatticeDistances(3,1)=R*sqrt(2);
  LatticeDistances(2,4)=R*sqrt(2); LatticeDistances(4,2)=R*sqrt(2);
    % bottom plane
  LatticeDistances(5,7)=R*sqrt(2); LatticeDistances(7,5)=R*sqrt(2);
  LatticeDistances(6,8)=R*sqrt(2); LatticeDistances(8,6)=R*sqrt(2);
    % side planes
  LatticeDistances(1,6)=R*sqrt(2); LatticeDistances(6,1)=R*sqrt(2);
  LatticeDistances(2,5)=R*sqrt(2); LatticeDistances(5,2)=R*sqrt(2);
  LatticeDistances(2,7)=R*sqrt(2); LatticeDistances(7,2)=R*sqrt(2);
  LatticeDistances(3,6)=R*sqrt(2); LatticeDistances(6,3)=R*sqrt(2);
  LatticeDistances(3,8)=R*sqrt(2); LatticeDistances(8,3)=R*sqrt(2);
  LatticeDistances(4,7)=R*sqrt(2); LatticeDistances(7,4)=R*sqrt(2);
  LatticeDistances(4,5)=R*sqrt(2); LatticeDistances(5,4)=R*sqrt(2);
  LatticeDistances(1,8)=R*sqrt(2); LatticeDistances(8,1)=R*sqrt(2);

  % Next-Next-Nearest Neighbours
  LatticeDistances(1,7)=R*sqrt(5); LatticeDistances(7,1)=R*sqrt(5);
  LatticeDistances(2,8)=R*sqrt(5); LatticeDistances(8,2)=R*sqrt(5);
  LatticeDistances(3,5)=R*sqrt(5); LatticeDistances(5,3)=R*sqrt(5);
  LatticeDistances(4,6)=R*sqrt(5); LatticeDistances(6,4)=R*sqrt(5);
end
