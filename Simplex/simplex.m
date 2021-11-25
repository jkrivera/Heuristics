% Data
A=[1 0 1 2; 0 2 1 5; 3 2 4 1];
b=[6; 16; 20];
c=[3 5 4 7];

B=[-c zeros(1,size(A,1)) 0; A diag(ones(1,size(A,1))) b];

vb = [size(A,2)+1:size(A,2)+size(B,1)-1]

% Simplex
% Prueba de optimalidad
it=0;
while min(B(1,1:end-1))<0
    it=it+1;
    % Variable básica entrante
%     [~,vbe]=min(B(1,1:end-1));
    [~,list]=find(B(1,1:end-1)<0);
    ind=randi(size(list,2));
    vbe=list(ind);
    % Criterio de la razón
    for i = 2:size(B,1)
        if B(i,vbe)>0
            CR(i)=B(i,end)/B(i,vbe);
        else
            CR(i)=inf;
        end
    end
    [a,b]=min(CR(2:end));
    if a>0 && a<inf
        vbs=vb(b);
    end
    vb(b)=vbe;
    [it vb]
    npivote=B(b+1,vbe);
    fpivote=B(b+1,:);
    % Operaciones EF
    for i = 1:size(B,1)
        if i ~= b+1
            num=B(i,vbe);
            for j = 1:size(B,2)
                B(i,j)=B(i,j)-num/npivote*fpivote(j);
            end
        else
            for j = 1:size(B,2)
                B(i,j)=B(i,j)/npivote;
            end
        end
    end
end

['Z  = ' mat2str(B(1,end))]
for i=2:size(B,1)
    ['X' mat2str(vb(i-1)) ' = ' mat2str(B(i,end))]
end