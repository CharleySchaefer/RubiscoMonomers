function LatticeDistances=main_LatticeModel(Lattice_type,param)
  
    switch Lattice_type
      case  'LatticeCube' 
  Ru_coordinates=...
    [0;     0;     0  ]; % Coordinates
  Ru_angles=...
    [0;     0;     0   ];
  [LatticeCoor, LatticeDistances]=Lattice_Rubisco(Ru_coordinates, Ru_angles);
      case  'RubiscoSphere' 
       Rub_Radius=param(1);
       Rub_Angle =param(2);
  [LatticeCoor, LatticeDistances]=Rubisco_Sphere(Rub_Radius, Rub_Angle);
        
      case  'PatchyParticle' 
        delim=' ';
        Nheader=0;
        fname_coor=param;
   [LatticeCoor, LatticeDistances]=getPatchyParticle(fname_coor, delim, Nheader);      
      case 'Triangle' 
        LatticeCoor=[];
        LatticeDistances=[0.0 7.7 7.7;
                          7.7 0.0 7.7;
                          7.7 7.7 0.0 ];
    end
end
