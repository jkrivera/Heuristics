function [Sp,ns,res,fullres]=N4(Prec, dur, nprec, nrec, rec, nt, R, S, ns, res, fullres, id)
%% N4: L-Interchange

Sp=S;

for i1=2:nt-1
    for l1=0:2
        for i2=i1+l1+1:nt-1
            for l2=0:2
                if i2+l2<nt
                    if l2+l1>0
                        for j1=2:nt-1-l1-l2
                            for j2=2:nt-1
                                s1=S.sol(i1:i1+l1);
                                s2=S.sol(i2:i2+l2);
                                V.sol=[S.sol(1:i1-1) S.sol(i1+l1+1:i2-1) S.sol(i2+l2+1:end)];
                                
                                
                                
                                
                                
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
                    end
                end
            end
            
        end
    end
    
end