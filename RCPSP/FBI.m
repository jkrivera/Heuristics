function [S,ns,res,fullres] = FBI(Prec, dur, nprec, nsuc, nrec, rec, nt, R, S, ns, res, fullres, id, opt)

[~, ord] = sortrows(S.St(2:nt-1)'+dur(2:nt-1),'descend');
ord=[nt ord'+1 1];
Sinv.sol=nt+1-ord;
Sinv = makespan(Sinv, Prec(nt:-1:1,nt:-1:1)', nsuc(nt:-1:1), dur(nt:-1:1), rec(:,nt:-1:1), R, nrec, nt);

[~, ord] = sortrows(Sinv.St(2:nt-1)'+dur(nt-1:-1:2),'descend');
ord=[nt ord'+1 1];
Sp.sol=nt+1-ord;
Sp = makespan(Sp, Prec, nprec, dur, rec, R, nrec, nt);

ns=ns+1;

if S.C>Sp.C
    S=Sp;
end

if ns==1000 && res==1
    fullres(id,res)=S.C;
    res=res+1;
end
if ns==5000 && res==2
    fullres(id,res)=S.C;
    res=res+1;
end
if ns==50000 && res==3
    fullres(id,res)=S.C;
    res=res+1;
    res=8;
end
if ns==100000 && res==4
    fullres(id,res)=S.C;
    res=res+1;
end
if ns==200000 && res==5
    fullres(id,res)=S.C;
    res=res+1;
end
if ns==500000 && res==6
    fullres(id,res)=S.C;
    res=res+1;
end
if ns==1000000 && res==7
    fullres(id,res:end)=S.C;
    res=res+1;
end

if opt==S.C
    fullres(id,res:end)=S.C;
    res=8;
end

end