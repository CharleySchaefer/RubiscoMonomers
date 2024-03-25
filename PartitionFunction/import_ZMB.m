% ZM1
function [B,M,ZMB, lK]=import_ZMB(RubiscoModel, f_prefix, varargin)
  switch varargin{1}
    case 'specific-lk'
      lK=varargin{2};
      if length(varargin)>2
        Slength=varargin{3};
      else
        fprintf('Warning: Spacer length assumed equal to 50\n');
        Slength=50;
      end
      [B,M,ZMB]=import_specific_ZMB(RubiscoModel, ZS, lK, Slength);
    case 'specific-fene'
      Radius=varargin{2};
      Angle=varargin{3};
      [B,M,ZMB]=import_specific_ZMB_FENE(RubiscoModel, ZS, Radius, Angle);
    case 'all-lk'
    RubiscoModel
    f_prefix
      [B, M, ZMB, lK]= import_all_ZMB(RubiscoModel, f_prefix);
    otherwise 
      varargin
      error('Unexpected argument\n');
    
    
  end
end

function  [B,M,ZMB]=import_specific_ZMB(RubiscoModel, ZS, lK, varargin)


  pth=strcat('Data/', RubiscoModel);
  
  %-------------------------------------------------
  % Import partition functions
  % Properties of ZMB files
  delim=' ';
  Nheader=1;
  Nsites=8;  % TODO: read Nsites from ZMB file
  
  if(length(varargin)==1) % Length specified
    Slength=varargin{1};
    fname=sprintf('%s/ZMB_FJC_ZS%d_Slength%d_%.2f.out',pth,ZS,Slength, lK);
  else
    fname=sprintf('%s/ZMB_FJC_ZS%d_%.2f.out',pth,ZS, lK);
  end
  try   data=importdata(fname,delim,Nheader);
  catch
    if Slength==50
      fname=sprintf('%s/ZMB_FJC_ZS%d_%.2f.out',pth,ZS, lK);
      data=importdata(fname,delim,Nheader);
    end
    
    
  end
  
  try data=data.data;
  end
  
    B=[data(:,1)];
    M=[data(:,2)];
    ZMB=[data(:,5)];
  if( B(1)~=0 && M(1)~=0 ) % Empty lattice!
    B=[0;B];
    M=[0;M];
    ZMB=[1;ZMB];
  end
  %-------------------------------------------------

end

function  [B,M,ZMB]=import_specific_ZMB_FENE(RubiscoModel, ZS, lK, varargin)


  pth=strcat('Data/', RubiscoModel);
  
  %-------------------------------------------------
  % Import partition functions
  % Properties of ZMB files
  delim=' ';
  Nheader=1;
  Nsites=8;  % TODO: read Nsites from ZMB file
  
  if(length(varargin)==1) % Length specified
    Slength=varargin{1};
    fname=sprintf('%s/ZMB_FJC_ZS%d_Slength%d_%.2f.out',pth,ZS,Slength, lK);
  else
    fname=sprintf('%s/ZMB_FJC_ZS%d_%.2f.out',pth,ZS, lK);
  end
  try   data=importdata(fname,delim,Nheader);
  catch
    if Slength==50
      fname=sprintf('%s/ZMB_FJC_ZS%d_%.2f.out',pth,ZS, lK);
      data=importdata(fname,delim,Nheader);
    end
    
    
  end
  
  try data=data.data;
  end
  
    B=[data(:,1)];
    M=[data(:,2)];
    ZMB=[data(:,5)];
  if( B(1)~=0 && M(1)~=0 ) % Empty lattice!
    B=[0;B];
    M=[0;M];
    ZMB=[1;ZMB];
  end
  %-------------------------------------------------

end

% Files of the form Data/'RubiscoModel'/'f_prefix'_%f.out will be imported

function [B_all, M_all, ZMB_all, lKrow]= import_all_ZMB(RubiscoModel, f_prefix)
  delim= ' ';
  Nheader=1;
  
  filelist = dir(sprintf('Data/%s/%s_*.out',RubiscoModel,f_prefix));
  lKrow = zeros(1, length(filelist));
  NlK=length(lKrow);
  NFILES=length(filelist);
  count=0;
  rm_i=[];
  for i = 1:NFILES
    
    % READ LK FROM FILENAME
    filename = filelist(i).name
    lK = sscanf(filename, sprintf('%s_%%f.out', f_prefix)  );
    lKrow(i)=lK;
    
    % READ CONTENTS OF FILE
    data=importdata(sprintf('Data/%s/%s', RubiscoModel, filename), delim, Nheader);
    try data=data.data; end
    
    B_all=data(:,1);
    M_all=data(:,2);
    ZMB=data(:,5);
    if i==1
      [Npartitions, ~]=size(ZMB);
      Npartitions=Npartitions+1;
      ZMB_all=zeros(NlK, Npartitions);
    end
    
    B_all=[0;B_all];
    M_all=[0;M_all];
    ZMB_all(i,:) =([1;ZMB]);
  end
  
end

function [B_all, M_all, ZMB_all, lKrow]= import_all_ZMB_0(RubiscoModel, ZS)
  %Npartitions=34;
  
  delim= ' ';
  Nheader=1;
  %NlK=length(lKrow);
  filelist = dir(sprintf('Data/%s/ZMB_FJC_ZS%d_*.out',RubiscoModel,ZS));
  %filelist = dir(sprintf('Data/%s/ZMB_FJC_chlam_*.out',RubiscoModel));
lKrow = zeros(1, length(filelist));
NFILES=length(filelist);
count=0;
rm_i=[];
for i = 1:NFILES
    filename = filelist(i).name;
    filename;
    count=count+1;
    try
    lK = sscanf(filename, sprintf('ZMB_FJC_ZS%d_%%f.out', ZS)  ); %;sprintf('Data/chlamy/ZMB_FJC_ZS%d_%%f.out', ZS));
   % lK = sscanf(filename, sprintf('ZMB_FJC_chlam_%%f.out')  ); %;sprintf('Data/chlamy/ZMB_FJC_ZS%d_%%f.out', ZS));
    lKrow(i) = lK;
    catch
    try
      rm_i=[rm_i, i];
      continue
    
      sprintf('ZMB_FJC_Slength%d_%%f.out', ZS);
      lK = sscanf(filename, sprintf('ZMB_FJC_ZS%d_Slength50_%%f.out', ZS)  );
      lKrow(count) = lK;
      catch
      rm_i=[rm_i, i];
      continue
      
      lKrow(end)=[];
      count=count-1;
    end
    end
end
  len_rm=length(rm_i);
  for j=1:len_rm % Remove data
    i=rm_i(len_rm+1-j);
  %  logZMB_all(i,:) =[];
    lKrow(i)=[];
  end

  NlK=length(lKrow);

  rm_i=[];
  for i=1:NlK
    
    lK=lKrow(i); 
    try
      fname_ZMB=sprintf('Data/%s/ZMB_FJC_ZS%d_%.2f.out', RubiscoModel, ZS, lK);
      data=importdata(fname_ZMB, delim, Nheader);
   catch
   
    rm_i=[rm_i, i];
    continue
   fname_ZMB=sprintf('Data/%s/ZMB_FJC_ZS%d_Slength50_%.2f.out', RubiscoModel, ZS, lK);
  data=importdata(fname_ZMB, delim, Nheader);
    %lK = sscanf(filename, sprintf('ZMB_FJC_ZS%d_Slength50_%%f.out', ZS)  )
    end
    %fname_ZMB=sprintf('Data/%s/ZMB_FJC_chlam_%.2f.out', RubiscoModel, lK);
    try data=data.data;
    catch
      rm_i=[rm_i, i];
      continue
    end
  
    B_all=data(:,1);
    M_all=data(:,2);
    ZMB=data(:,5);
    if i==1
      [Npartitions, ~]=size(ZMB);
      Npartitions=Npartitions+1; 
      ZMB_all=zeros(NlK, Npartitions);
    end
  
    B_all=[0;B_all];
    M_all=[0;M_all];
    ZMB_all(i,:) =([1;ZMB]);
    
  
    %logZMB_all(i,:) =log([1;ZMB]);
  

    if(length(B_all)~=Npartitions)
      error('Assumed number of partitions is wrong\n');
    end
  end
  len_rm=length(rm_i);
  for j=1:len_rm % Remove data
    i=rm_i(len_rm+1-j);
    ZMB_all(i,:) =[];
    lKrow(i)=[];
  end
  
  if min(M_all)==1
    B_all=[0;B_all];
    M_all=[0;M_all];
    size(ZMB_all);
    ZMB_all=[zeros(NlK,1), ZMB_all];
    size(ZMB_all);
  end

end

function [B_all,M_all,ZMB_all]=import_ZMB_file(fname)
   data=importdata(fname_ZMB, delim, Nheader);
   try data=data.data;
   end
   
   
    B_all=data(:,1);
    M_all=data(:,2);
    ZMB=data(:,5);
    if i==1
      [Npartitions, ~]=size(ZMB);
      Npartitions=Npartitions+1; 
      ZMB_all=zeros(NlK, Npartitions);
    end
  
    B_all=[0;B_all];
    M_all=[0;M_all];
    ZMB_all(i,:) =([1;ZMB]);
    
  
    %logZMB_all(i,:) =log([1;ZMB]);
  

    if(length(B_all)~=Npartitions)
      error('Assumed number of partitions is wrong\n');
    end
    
end
