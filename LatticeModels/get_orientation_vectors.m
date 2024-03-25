% R0: n by 3 matrix
% a,b,c: rotation angle around x,y,z axes, respectively
% Rotate vectors
function R=get_orientation_vectors(R0,a,b,c)
  [m,n]=size(R0);
  if m~=3
    error('R0 should have dimensions n by 3');
  end
  R=zeros(m,n);
  Trot=rotation_matrix(a,b,c);

  for i=1:n
    % Rotate vector 'i' from R0 and store in R
    R(:,i) = Trot*R0(:,i);
  end

end
