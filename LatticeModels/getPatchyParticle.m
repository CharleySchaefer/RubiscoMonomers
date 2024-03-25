function [LatticeCoordinates, LatticeDistances]=getPatchyParticle(f_name, delim, Nheader)

  %==============================================
  %delim=' ';
  %Nheader=0;
  %f_name='PatchyParticle_Rubisco_Chlamy.out';
  %==============================================
  
  % Get coordinates
  coor=importdata(f_name, delim, Nheader);  
  LatticeCoordinates=coor(:,1:3);
  
  % Division by 10: assume input is in Angstrom, return nanometers
  LatticeDistances=PatchySphere_Coor2Dist(LatticeCoordinates)/10;
end
