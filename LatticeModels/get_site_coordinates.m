% Function takes 3*n array rall0 of length-3 coordinate vectors, rotates the vectors  by angles a,b,c, around x,y,z axes respectively, and shifts the centre of mass to Rcm.
% The new coordinates are stored in the 3*n Rsites array
function Rsites=get_site_coordinates(rall0,Rcm,a,b,c)
 
  Rsites  =get_orientation_vectors(rall0,a,b,c); % Rotate unit cell
  Rsites(1,:) = Rsites(1,:)+Rcm(1);                  % Shift centre of mass
  Rsites(2,:) = Rsites(2,:)+Rcm(2);
  Rsites(3,:) = Rsites(3,:)+Rcm(3); 

end
