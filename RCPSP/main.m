function result=rcpsp(method,result)
%% Metaheuristics
%  1. Slack-based construction (SBM)
%  2. SBM + FBI
%  3. VND(4)
%  4. ILS
%  5. ILS+VND(3)
%  6. GA (Activity list representation)
%  7. RKGA (Random Key representation)
%  8. BRKGA (Biased RKGA)
%  9. BRKGA-P (BRKGA on priority rules)
% 10. BRKGA-PA (BRKGA on priority rules for each activity)
% 11. Solución Aleatoria

%clear all -summary
%clc
format 'bank'

if exist('method')
    met=method.id;
    nvec=method.nvec;
else
    met=3;
    nvec=4;
end

if ~exist('result')
    result(met).id=met;
end

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
    
    if met==1 || met==2 || met==3
        % Activity list based on slacks
        S = SlackMethod(Prec, dur, nprec, nrec, rec, nt, R);
        ns = 1;
        %         if met==1
        %             fin=1;
        %         end
    end
    if met==2 || met==3
        [S,ns,res,fullres] = FBI(Prec, dur, nprec, nsuc, nrec, rec, nt, R, S, ns, res, fullres, id, opt);
        %         error = validation(S, Prec, dur, nprec, nrec, rec, nt, R);
    end
    
    if met==3
        % VND with four neighborhoods
        [S,ns,res,fullres] = VND(Prec, dur, nprec, nsuc, nrec, rec, nt, R, S, ns, nvec, res, fullres, id, opt);
        %         error = validation(S, Prec, dur, nprec, nrec, rec, nt, R);
    end
    
    error = validation(S, Prec, dur, nprec, nrec, rec, nt, R);
    if length(error)>0
        i=i;
    end
    
    if res>1
        res=res;
    end
    fullres(id,res:end)=S.C;
    
    t=t+toc;
    prom(id,:)=(fullres(id,:)-opt)/opt*100;
    
end
t;
[mean(prom(1:480,:)) mean(prom(481:960,:)) mean(prom(961:1440,:)) mean(prom(1441:2040,:)) mean(prom)]
%mean(prom(1441:2040,:))
%mean(prom)
result=0;
end