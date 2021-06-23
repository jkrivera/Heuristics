function [Sp,ns,res,fullres]=N2(Prec, dur, nprec, nrec, rec, nt, R, S, ns, res, fullres, id, opt)
%% N2: Insertion to left

Sp=S;

for i=2:nt-1
    for j=i-1:-1:2
        if Prec(S.sol(j),S.sol(i))==0
            if S.St(S.sol(j))<S.St(S.sol(i))
                
                ns=ns+1;
                V=S;
                for k=j:i-1
                    V.sol(k+1)=S.sol(k);
                end
                V.sol(j)=S.sol(i);
                
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
        else
            break
        end
        
    end
end

end