function [Sp,ns,res,fullres]=N4(Prec, dur, nprec, nsuc, nrec, rec, nt, R, S, ns, res, fullres, id, opt)
%% N4: L-Interchange

Sp=S;
% stop=0;

for i1=2:nt-1
    for l1=0:1
        s1=S.sol(i1:i1+l1);
        for i2=i1+l1+1:nt-1
            for l2=0:1
                if i2+l2<nt
                    s2=S.sol(i2:i2+l2);
                    for j1=2:nt-1-l1-l2
                        for j2=2:nt-1-l2
                            if i1~=j1 || i2~=j2
                                V.sol=[S.sol(1:i1-1) S.sol(i1+l1+1:i2-1) S.sol(i2+l2+1:end)];
                                V.sol=[V.sol(1:j1-1) s1 V.sol(j1:end)];
                                V.sol=[V.sol(1:j2-1) s2 V.sol(j2:end)];
                                f=ValPrec(V.sol, Prec, nprec, nt);
                                if f==1
                                    ns=ns+1;
                                    V = makespan(V, Prec, nprec, dur, rec, R, nrec, nt);
                                    
                                    [V,ns,res,fullres] = FBI(Prec, dur, nprec, nsuc, nrec, rec, nt, R, V, ns, res, fullres, id, opt);
                                    
                                    if Sp.C > V.C
%                                         stop=1;
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
                            end
                            if res==8% || stop==1
                                break;
                            end
                        end
                        if res==8% || stop==1
                            break;
                        end
                    end
                end
            end
            if res==8% || stop==1
                break;
            end
        end
    end
    if res==8% || stop==1
        break;
    end
end

end