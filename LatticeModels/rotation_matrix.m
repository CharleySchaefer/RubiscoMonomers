% a,b,c: rotation angle around x,y,z axes, respectively
function R=rotation_matrix(a,b,c)
  sa=sin(a); ca=cos(a);
  sb=sin(b); cb=cos(b);
  sc=sin(c); cc=cos(c);
  R=[ cb*cc, sa*sb*cc-ca*sc, ca*sb*cc+sa*sc;
      cb*sc, sa*sb*sc+ca*cc, ca*sb*sc-sa*cc;
        -sb,          sa*cb, ca*cb          ];
end


