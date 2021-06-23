function [sol,Z]=Rand_MAR_Shaffer(nt,dur,Prec,nprec,nsuc,nrec,rec,recu)
tic

fin=0;
ESlist(1,nt)=0;
while fin==0
    %% Paso 1: Calcular ES (Early start) y EF (Early finish) de cada actividad
    ES=zeros(1,nt);
    EF=zeros(1,nt);
    check=zeros(1,nt);
    npprog=zeros(1,nt);
    nsprog=zeros(1,nt);
    for it=1:nt
        for j=1:nt
            if check(j)==0 && npprog(j)==nprec(j)
%                npprog(j)=0;
                for i=1:nt
%                    if Prec(i,j)==1
%                        npprog(j)=npprog(j)+1;
%                        if ES(j)<EF(i)
%                            ES(j)=EF(i);
%                        end
%                    end
                    if Prec(i,j)==1 && ES(j)<EF(i)
                        %npprog(j)=npprog(j)+1;
                        ES(j)=EF(i);
                    end
                    if Prec(j,i)==1
                        npprog(i)=npprog(i)+1;
%                        nsprog(j)=nsprog(j)+1;
                    end
%                    if nsprog(j)==nsuc(j) && npprog(j)==nprec(j)
%                        break;
%                    end
                end
                EF(j)=ES(j)+dur(j);
                check(j)=1;
                break;
            end
        end
    end
    
    %% Paso 2: Calcular LF (Late finish) y LS (Late start)
    LF=ones(1,nt)*EF(nt);
    LS=ones(1,nt)*EF(nt);
    check=zeros(1,nt);
    nsprog=zeros(1,nt);
    for it=1:nt
        for i=nt:-1:1
            if check(i)==0 && nsprog(i)==nsuc(i)
                for j=nt:-1:1
                    if Prec(i,j)==1 && LF(i)>LS(j)
                        LF(i)=LS(j);
                    end
                    if Prec(j,i)==1
                        nsprog(j)=nsprog(j)+1;
                    end
                end
                LS(i)=LF(i)-dur(i);
                check(i)=1;
                break;
            end
        end
    end
    
    %     %% Paso 3: Holguras H
    %     for j=1:nt
    %         H(j)=LF(j)-EF(j);
    %     end
    
    %% Paso 4: Calcular recursos requeridos en cada periodo de tiempo
    RR=zeros(EF(nt),nrec);
    for j=1:nt
        for t=ES(j)+1:EF(j)
            for k=1:nrec
                RR(t,k)=RR(t,k)+rec(k,j);
            end
        end
    end
    
    %% Paso 5: Agregar restricciones
    tp=0;
    constrec=zeros(1,nrec);
    for t=1:EF(nt)
        for k=1:nrec
            if RR(t,k)>recu(k)
                tp=t;
                constrec(k)=1;
            end
        end
        if tp~=0
            break;
        end
    end
    
    if tp~=0
        RCL=0;
        for j=1:nt
            if ES(j)<tp && EF(j)>=tp
                for k=1:nrec
                    if rec(k,j)>=constrec(k)
                        RCL(1)=RCL(1)+1;
                        RCL(RCL(1)+1)=j;
                        break;
                    end
                end
            end
        end
        menorEF=RCL(randi(RCL(1))+1);
        mayorLS=menorEF;
        while mayorLS==menorEF
            mayorLS=RCL(randi(RCL(1))+1);
        end
  
        Prec(menorEF,mayorLS)=1;
        nprec(mayorLS)=nprec(mayorLS)+1;
        nsuc(menorEF)=nsuc(menorEF)+1;
    else
        fin=1;
    end
end

check=zeros(1,nt);
sol=1;
for i=2:nt
    sel=0;
    for j=2:nt
        if check(j)==0
            if sel==0 || ES(j)<ES(sel)
                sel=j;
            end
        end
    end
    check(sel)=1;
    sol=[sol sel];
end

Z=ES(nt);

toc
end