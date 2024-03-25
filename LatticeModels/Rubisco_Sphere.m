function [LatticeCoordinates, LatticeDistances]=Rubisco_Sphere(Radius, PatchAngle)
  %Radius=6.8; % nm
  %PatchAngle=45; % degrees
  Nsites=8;
  
  
  % GET COORDINATES
  LatticeCoordinates=zeros(Nsites,3);
  % z-coordinate
  theta=pi*(180-PatchAngle)/180;
  z=Radius*cos(theta);   % height
  rho=Radius*sin(theta) % radius in xy plane
  patchID=0;
  for i=-1:2:1
    Z=i*z;
    for j=-1:2:1
      Y=j*rho/sqrt(2);
      for k=-1:2:1
        X=k*rho/sqrt(2);
        patchID=patchID+1;
        LatticeCoordinates(patchID,:) = [X,Y,Z];
        
        
        %fprintf('%d %d %d\n',i,j,k);
      %  fprintf('%.3f %.3f %.3f\n', i*z, j*rho/sqrt(2), k*rho/sqrt(2)) ; % print coordinates
       % R=sqrt(X*X+Y*Y+Z*Z);
      %  plot3(Z, Y, X, '.k', 'MarkerSize', 15); hold on
      %  axis([-Radius,Radius,-Radius,Radius,-Radius,Radius])
      end
    end
  end
 
  
  % CONVERT COORDINATES TO DISTANCES
  LatticeDistances=PatchySphere_Coor2Dist(LatticeCoordinates); 
  
end
