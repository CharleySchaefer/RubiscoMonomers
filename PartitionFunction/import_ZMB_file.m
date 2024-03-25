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
