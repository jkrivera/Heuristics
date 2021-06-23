%Metodo constructivo
%Criterio de decision: duracion menor de las actividades
%Entradas: Prec, duraciones, nt
%Salidas: solucion
function [solucion]=AntSlack2(Prec, duraciones, nprec, nrec, rec, nt, cantidadRecursos,F,w)
solucion=zeros(1,nt); %Vector con el orden de las actividades
asignacion=zeros(1,nt); %Vector que permite saber cuales actividades ya han sido asignadas (las que tienen 1)
%Prec2=Prec;

%Asignacion de la 1era actividad (ficticia)
if sum(Prec(:,1))==0 %La actividad 1 no tiene restricciones de precedencia
    solucion(1)=1;
    asignacion(1)=1;
%    Prec2(1,:)=zeros(1,nt); %Se elimina como precedencia porque ya se cumplio
    ES=zeros(1,nt);
    EF=zeros(1,nt);
    LF=zeros(1,nt);
    
    nprec2=Prec(1,:);
    
    elegible=find(nprec2(2:nt)==nprec(2:nt))+1;
    
    cumres=zeros(nrec,sum(duraciones));
    
    for i=2:nt %Se va construyendo el vector Solucion
        
        %compute the early start and the early finish
        for j=2:nt
            if asignacion(j)~=1
                ES(j)=max(EF.*Prec(:,j)');
                EF(j)=ES(j)+duraciones(j);
            end
        end
        
        %compute the late start and late finish
        set=find(asignacion~=1);
        LF(set)=EF(nt);
        LS(nt)=LF(nt)-duraciones(nt);
        for j=nt-1:-1:2
            if asignacion(j)~=1
                LF(j)=min(LS(Prec(j,:)~=0));
                LS(j)=LF(j)-duraciones(j);
            end
        end
        
        Slack=LF-EF;
        
        P=zeros(1,length(elegible));
        suma=0;
        for j=1:length(elegible)
            for k=2:nt-1
                if asignacion(k)==0 && k~=elegible(j)
                    P(j)=P(j)+F(elegible(j),k);
                end
            end
            P(j)=P(j)/(nt-i-1);
            P(j)=P(j)*w+(1-w)*(1/(Slack(elegible(j))+1));
            suma=suma+P(j);
        end
        P=P/suma;
        r=rand;
        for j=1:length(elegible)
            if j~=1
                P(j)=P(j)+P(j-1);
            end
            if P(j)>r
                e=elegible(j);
                break;
            end
        end
            
        
        t=ES(e)+1;
        while t<=ES(e)+duraciones(e)
            for r=1:nrec
                if cumres(r,t)+rec(r,e)>cantidadRecursos(r)
                    ES(e)=t;
                    break;
                end
            end
            t=t+1;
        end
        EF(e)=ES(e)+duraciones(e);
        LS(e)=ES(e);
        LF(e)=EF(e);
        for t=ES(e)+1:EF(e)
            for r=1:nrec
                cumres(r,t)=cumres(r,t)+rec(r,e);
            end
        end
        asignacion(e)=1;
        
        elegible=elegible(elegible~=e);
        
        nprec2=nprec2+Prec(e,:);
        
        for j=2:nt
            if Prec(e,j)==1
                if nprec(j)==nprec2(j)
                    elegible=[elegible j];
                end
            end
        end
        
        solucion(i)=e;
            
    end
    
end

solucion(nt+1)=LS(nt);

end
