function  [B_all, M_all, lKrow, logZMB_all]= importZMB(ZS, RubiscoModel)
  %Npartitions=34;
  
  delim= ' ';
  Nheader=1;
  %NlK=length(lKrow);
  filelist = dir(sprintf('Data/%s/ZMB_FJC_ZS%d_*.out',RubiscoModel,ZS));
  %filelist = dir(sprintf('Data/%s/ZMB_FJC_chlam_*.out',RubiscoModel));
lKrow = zeros(1, length(filelist));
NFILES=length(filelist)
count=0;
rm_i=[];
for i = 1:NFILES
    filename = filelist(i).name;
    filename
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
      logZMB_all=zeros(NlK, Npartitions);
    end
  
    B_all=[0;B_all];
    M_all=[0;M_all];
  
    logZMB_all(i,:) =log([1;ZMB]);
  

  %  data=importdata(fname, ' ', 1);
  %  try data=data.data;
  %  end
  %  B_all=data(:,1);
    if(length(B_all)~=Npartitions)
      error('Assumed number of partitions is wrong\n');
    end
  %  M_all=data(:,2);
   % logZMB_all(i,:)=log(data(:,5));
  end
  len_rm=length(rm_i)
  for j=1:len_rm % Remove data
    i=rm_i(len_rm+1-j);
    logZMB_all(i,:) =[];
    lKrow(i)=[];
  end
  
  if min(M_all)==1
    B_all=[0;B_all];
    M_all=[0;M_all];
    size(logZMB_all);
    logZMB_all=[zeros(NlK,1), logZMB_all];
    size(logZMB_all);
  end

end
