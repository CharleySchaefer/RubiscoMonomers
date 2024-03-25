function Polymer_sequence=get_sequence(Model, varargin)
  
  switch Model
    case 'EPYC1_5RBM'     sseq='00000000000000010000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000001';
      Polymer_sequence=zeros(length(sseq),1);
      for i=1:length(sseq)
        Polymer_sequence(i)=str2num(sseq(i));
      end
    case 'EPYC1_2RBM'
sseq='00000000000000000000000010000000000000000000000000000000000000000000000000100000000000000000000000000';
      Polymer_sequence=zeros(length(sseq),1);
      for i=1:length(sseq)
        Polymer_sequence(i)=str2num(sseq(i));
      end
    case 'RegularSequence'
      if(length(varargin)<2)
        error('Arguments missing. Expected: "RegularSequence", SpacerLength, ZS\n');
      end
      SpacerLength=varargin{1};
      ZS          =varargin{2};
    
      repeatunit=[zeros(1,SpacerLength), 1];
      Polymer_sequence=[];
      for i=1:ZS
        Polymer_sequence=[Polymer_sequence,repeatunit];
      end
    otherwise
      fprintf('Model: "EPYC1_5RBM", "EPYC1_2RBM", or "RegularSequence"\n')
  end
end
