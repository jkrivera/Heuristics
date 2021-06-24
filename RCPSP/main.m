function main(met)
%% Metaheuristics
% 1. VND(4)
% 2. ILS
% 3. ILS+VND(3)
% 4. GA (Activity list representation)
% 5. RKGA (Random Key representation)
% 6. BRKGA (Biased RKGA)
% 7. BRKGA-P (BRKGA on priority rules)
% 8. BRKGA-PA (BRKGA on priority rules for each activity)
% 9. Solución Aleatoria

clear all -summary
%clc
format 'bank'

met=1;
nvec=4;

tic;

fin=0;
id=0;
t=0;
maxns=0;
minns=500000;

fullres = zeros(2040,8);
prom = zeros(2040,8);

while fin==0
    % Data reading
    [id,fin,nt,nrec,nprec,nsuc,dur,Prec,R,rec,opt]=reading(id,fin);
    res=1;
    
    tic
    
    if met==1
        % Activity list based on slacks
        S = SlackMethod(Prec, dur, nprec, nrec, rec, nt, R);
        ns = 1;
        [S,ns,res,fullres] = FBI(Prec, dur, nprec, nsuc, nrec, rec, nt, R, S, ns, res, fullres, id, opt);
    end
    
    if met==1
        % VND with four neighborhoods
        [S,ns,res,fullres] = VND(Prec, dur, nprec, nsuc, nrec, rec, nt, R, S, ns, nvec, res, fullres, id, opt);
    end
    
    fullres(id,res)=S.C;
    t=t+toc;
    prom(id,1:3)=(fullres(id,1:3)-opt)/opt*100;
    
end
t
sum(prom(1:id,3))/id
t;