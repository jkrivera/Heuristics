function [Sp,ns,res,fullres]=N3(Prec, dur, nprec, nrec, rec, nt, R, S, ns, res, fullres, id, opt)
%% N3: Interchange

Sp=S;

for i=2:nt-1
    for j=i+1:nt-1
        if Prec(S.sol(i),S.sol(j))==0
            if S.St(S.sol(i))<S.St(S.sol(j))
                cont=1;
                for k = j-1:-1:i+1
                    if Prec(S.sol(k),S.sol(j))==1
                        cont=0;
                    end
                end
                if cont==1
                    
                    ns=ns+1;
                    V=S;
                    V.sol(j)=S.sol(i);
                    V.sol(i)=S.sol(j);
                    
                    V = makespan(V, Prec, nprec, dur, rec, R, nrec, nt);
                    
                    if Sp.C > V.C
                        stop=0;
                        Sp = V;
                    end
                    
                    if ns==1000 && res==1
                        fullres(id,res)=Sp.C;
                        res=res+1;
                    end
                    if ns==5000 && res==2
                        fullres(id,res)=Sp.C;
                        res=res+1;
                    end
                    if ns==50000 && res==3
                        fullres(id,res)=Sp.C;
                        res=res+1;
                    end
                    if ns==100000 && res==4
                        fullres(id,res)=Sp.C;
                        res=res+1;
                    end
                    if ns==200000 && res==5
                        fullres(id,res)=Sp.C;
                        res=res+1;
                    end
                    if ns==500000 && res==6
                        fullres(id,res)=Sp.C;
                        res=res+1;
                    end
                    if ns==1000000 && res==7
                        fullres(id,res)=Sp.C;
                        res=res+1;
                    end
                    if opt==Sp.C
                        fullres(id,res)=Sp.C;
                        res=8;
                    end
                end
            end
        else
            break
        end
        
    end
end

end