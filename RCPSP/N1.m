function [Sp,ns,res,fullres]=N1(Prec, dur, nprec, nsuc, nrec, rec, nt, R, S, ns, res, fullres, id, opt)
%% N1: Insertion to right

Sp=S;

for i=2:nt-1
    for j=i+1:nt-1
        if Prec(S.sol(i),S.sol(j))==0
            if S.St(S.sol(i))<S.St(S.sol(j))
                
                ns=ns+1;
                V=S;
                for k=i+1:j
                    V.sol(k-1)=S.sol(k);
                end
                V.sol(j)=S.sol(i);
                
                V = makespan(V, Prec, nprec, dur, rec, R, nrec, nt);
                
                [V,ns,res,fullres] = FBI(Prec, dur, nprec, nsuc, nrec, rec, nt, R, V, ns, res, fullres, id, opt);
                
                if Sp.C > V.C
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
                    res=8;
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
                    fullres(id,res:end)=Sp.C;
                    res=res+1;
                end
                
                if opt==Sp.C
                    fullres(id,res:end)=Sp.C;
                    res=8;
                end
            end
        else
            break
        end
        if res==8
            break;
        end
    end
    if res==8
        break;
    end
end

end