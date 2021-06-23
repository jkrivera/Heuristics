clc
clear
text='3';

t=0;

eq=0;
if strcmp(text,'12')
    sets=60;
else
    sets=48;
end

K=Inf;
tlim=10;

tic

i3=0;
for i1=66%1:sets
    for i2=66%1:10
        i3=i3+1;
        
        %% Lectura de datos
        duracion=['C:\Google Drive\Algorithms\Instances\RCPSP\Datos' text '0\dura' num2str(i1) num2str(i2) '.txt']; %Duracion de cada actividad (Act. - Dur.)
        fileID = fopen(duracion,'r');
        duraciones=textscan(fileID, '%d%d'); %dura
        fclose(fileID);
        duraciones=[duraciones{1} duraciones{2}];
        duraciones=double(duraciones);
        
        recursos=['C:\Google Drive\Algorithms\Instances\RCPSP\Datos' text '0\core' num2str(i1) num2str(i2) '.txt']; %Consumo de recursos por actividad (Rec. - Act. - Cons.)
        fileID = fopen(recursos,'r');
        recursos=textscan(fileID, '%d%d%d'); % core
        fclose(fileID);
        recursos=[recursos{1} recursos{2} recursos{3}];
        
        predecesores=['C:\Google Drive\Algorithms\Instances\RCPSP\Datos' text '0\pred' num2str(i1) num2str(i2) '.txt']; %Restricciones de precedencia de actividades (Act. antes - Act. Desp.)
        fileID = fopen(predecesores,'r');
        predecesor=textscan(fileID, '%d%d'); %pred
        fclose(fileID);
        predecesor=[predecesor{1} predecesor{2}];
        
        cantidadRecursos=['C:\Google Drive\Algorithms\Instances\RCPSP\Datos' text '0\recu' num2str(i1) num2str(i2) '.txt']; %Disponibilidad de cada tipo de recurso (Rec. - Disp.)
        fileID = fopen(cantidadRecursos,'r');
        cantidadRecursos=textscan(fileID, '%d%d');  %recu
        fclose(fileID);
        cantidadRecursos=[cantidadRecursos{1} cantidadRecursos{2}];
        
        nt=size(duraciones,1);
        nrec=size(recursos,1)/nt;
        rec=zeros(nrec,nt);
        for i = 1:length(recursos)
            rec(recursos(i,1),recursos(i,2))=recursos(i,3);
        end
        
        Prec=zeros(nt,nt);	%es un arreglo (nt x nt) que indica si una actividad es
        % precedencia de otra (1) o no (0).
        lprec=zeros(nt,nt);
        lsuc=zeros(nt,nt);
        for i=1:size(predecesor,1)
            Prec(predecesor(i),predecesor(i,2))=1;
            lprec(predecesor(i,2),1)=lprec(predecesor(i,2),1)+1;
            lprec(predecesor(i,2),lprec(predecesor(i,2),1)+1)=predecesor(i);
            lsuc(predecesor(i,1),1)=lsuc(predecesor(i,1),1)+1;
            lsuc(predecesor(i,1),lsuc(predecesor(i,1),1)+1)=predecesor(i,2);
        end
        nprec=zeros(1,nt);
        for i=1:nt
            nprec(i)=sum(Prec(:,i));%es un vector con nt componentes que indica el
            % número de precedencias de cada actividad
        end
        nsuc=zeros(1,nt);
        for i=1:nt
            nsuc(i)=sum(Prec(i,:));%es un vector con nt componentes que indica el
            % número de precedencias de cada actividad
        end
        
        dur=duraciones(:,2);
        recu=cantidadRecursos(:,2);
        
        PrecInd=Prec;
        for k = 3:nt
            for i=1:k-1
                for j=i+1:k-1
                    if PrecInd(i,j)==1
                        if PrecInd(j,k)==1
                            PrecInd(i,k)=1;
                        end
                    end
                end
            end
        end
        
        tic;
        
        %% Critical path
        ES=zeros (1,nt);
        for i = 2:nt
            for j = 1:lprec(i,1)
                if ES(i)<ES(lprec(i,j+1))+duraciones(lprec(i,j+1),2)
                    ES(i)=ES(lprec(i,j+1))+duraciones(lprec(i,j+1),2);
                end
            end
        end
        LS=ones(1,nt)*ES(nt);
        LS(1)=0;
        for i = nt-1:-1:2
            for j = 1:lsuc(i,1)
                if LS(i)>LS(lsuc(i,j+1))-duraciones(i,2)
                    LS(i)=LS(lsuc(i,j+1))-duraciones(i,2);
                end
            end
        end
        H=LS-ES;
        
        RC=zeros(1,nt);
        rcv=zeros(1,nt);
        rcv(nt)=1;
        RC(1)=1;
        RC(2)=nt;
        i=1;
        while RC(RC(1)+1)~=1
            for j=1:lprec(RC(RC(1)+1),1)
                if H(lprec(RC(RC(1)+1),j+1))==0
                    RC(RC(1)+2)=lprec(RC(RC(1)+1),j+1);
                    rcv(lprec(RC(RC(1)+1),j+1))=1;
                    RC(1)=RC(1)+1;
                    break;
                end
            end
        end
        
        %% Alternative path
        criterio=zeros(1,nt);
        for i=2:nt-1
            if rcv(i)==0
                for k=1:nrec
                    criterio(i)=criterio(i)+double(duraciones(i,2))/double(recu(k))*double(rec(k,i));
                end
            end
        end
        
        ES=zeros (1,nt);
        for i = 2:nt
            for j = 1:lprec(i,1)
                if ES(i)<ES(lprec(i,j+1))+criterio(lprec(i,j+1))
                    ES(i)=ES(lprec(i,j+1))+criterio(lprec(i,j+1));
                end
            end
        end
        LS=ones(1,nt)*ES(nt);
        LS(1)=0;
        for i = nt-1:-1:2
            for j = 1:lsuc(i,1)
                if LS(i)>LS(lsuc(i,j+1))-criterio(i)
                    LS(i)=LS(lsuc(i,j+1))-criterio(i);
                end
            end
        end
        H=LS-ES;
        
        RA=zeros(1,nt);
        rca=zeros(1,nt);
        rca(nt)=1;
        RA(1)=1;
        RA(2)=nt;
        i=1;
        while RA(RA(1)+1)~=1
            for j=1:lprec(RA(RA(1)+1),1)
                if H(lprec(RA(RA(1)+1),j+1))==0
                    RA(RA(1)+2)=lprec(RA(RA(1)+1),j+1);
                    rca(lprec(RA(RA(1)+1),j+1))=1;
                    RA(1)=RA(1)+1;
                    break;
                end
            end
        end
        
        %% Combine routes
        RC(2:RC(1)+1)=RC(RC(1)+1:-1:2);
        RA(2:RA(1)+1)=RA(RA(1)+1:-1:2);
        JR=zeros(2,max(RC(1)+1,RA(1)+1));
        JR(1,1:RC(1))=RC(2:RC(1)+1);
        JR(2,1:RA(1))=RA(2:RA(1)+1);
        
        for i=1:length(JR(1,:))
            for j=1:length(JR(1,:))
                if JR(1,i)==JR(2,j) && JR(2,j)~=0 && JR(2,j)~=1 && JR(2,j)~=nt
                    i
                end
            end
        end
        
        %% Primer nodo del arbol
        
        Sol(1).S=1;
        Sol(1).E=[2 2];
        Sol(1).sel=1;
        Sol(1).t=zeros(1,RA(1)+RC(1)-4+1);
        Sol(1).r=zeros(nrec,RA(1)+RC(1)-4+1);
        Sol(1)
        Sol(1).r
        
        %% Crear nueva lista de predecesores y sucesores para actividades en la nueva lista conjunta
        while 
        
        
        toc
        Best
        
    end
end
toc