function BlochBoundary
%  Georg Mensah, Philip Buschmann, Jonas Moeck; TU Berlin; 2015
%% This function will impose Bloch-Periodic conditions to the relevant boaundaries
%Not yet finished!

%     % determine if element has node at image boundary
%     check = zeros(3,1);
%     for j = 1:3
%         if id(e2p0(k,j)) == idBlochImg
%             check(j,1) = 1;
%         end
%     end
%     
%     % adjust local matrices for bloch 
%     for j = 1:3
%         if check(j,1) ~= 0
%             mloc(j,:) = exp(1i*b*phi).*mloc(j,:);
%             mloc(:,j) = conj(exp(1i*b*phi)).*mloc(:,j);
%         end
%     end   
%     


%     %This three lines do the same, just faster
%     mask=ismember(e2p(k,:),topo.BlochImg);
%     mloc(mask,:)=exp(1i*b*phi).*mloc(mask,:);
%     mloc(:,mask) = conj(exp(1i*b*phi)).*mloc(:,mask);

%ToDo: check wheter ii=jj.'
% ii(ii>length(x)-length(topo.BlochRef))=length(x)-ii(ii>length(x)-length(topo.BlochRef))+1;
% jj(jj>length(x)-length(topo.BlochRef))=length(x)-jj(jj>length(x)-length(topo.BlochRef))+1;