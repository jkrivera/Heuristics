function [nt, nrec, dur, rec, DispRec, nprec, nsuc, Prec, PrecInd, lb]=LecturaRCPSP(contador1, contador2, Set)

        problema1=num2str(contador1)
        problema2=num2str(contador2)

        dur=['datos',Set,'\dura',problema1,problema2,'.txt']; %Duracion de cada actividad (Act. - Dur.)
        recursos=['datos',Set,'\core',problema1,problema2,'.txt']; %Consumo de recursos por actividad (Rec. - Act. - Cons.)
        predecesor=['datos',Set,'\pred',problema1,problema2,'.txt']; %Restricciones de precedencia de actividades (Act. antes - Act. Desp.)
        DispRec=['datos',Set,'\recu',problema1,problema2,'.txt']; %Disponibilidad de cada tipo de recurso (Rec. - Disp.)
        lb=['datos',Set,'\OPTIMOS32.txt']; %Disponibilidad de cada tipo de recurso (Rec. - Disp.)
        dur=textread(dur); %dura
        recursos=textread(recursos); % core
        predecesor=textread(predecesor); %pred
        DispRec=textread(DispRec);  %recu
        lb=textread(lb); %dura
        lb=lb(10*(contador1-1)+contador2,2);
        %lb=8;
        dur(:,1)=[];
        DispRec(:,1)=[];

        nt=size(dur,1);
        nrec=size(recursos,1)/nt;

        for i = 1:length(recursos)
            rec(recursos(i,1),recursos(i,2))=recursos(i,3);
        end
        clear recursos;
        
        Prec=zeros(nt,nt);	%es un arreglo (nt x nt) que indica si una actividad es
        % precedencia de otra (1) o no (0).

        for i=1:size(predecesor,1)
            Prec(predecesor(i),predecesor(i,2))=1;
        end
        nprec=zeros(1,nt);
        for i=1:nt
            nprec(i)=sum(Prec(:,i));%es un vector con nt componentes que indica el
            % numero de precedencias de cada actividad
        end
        nsuc=zeros(1,nt);
        for i=1:nt
            nsuc(i)=sum(Prec(i,:));%es un vector con nt componentes que indica el
            % numero de precedencias de cada actividad
        end
        PrecInd=Prec;
        for i1=nt-2:-1:1
            for i2=nt-1:-1:i1+1
                if PrecInd(i1,i2)==1
                    PrecInd(i1,:)=PrecInd(i1,:)+PrecInd(i2,:);
                end
            end
        end
        clear predecesor;
        
        end