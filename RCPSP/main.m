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
prom=zeros(1,4);

met=1;
nvec=3;

tic;

fin=0;
id=0;
t=0;
maxns=0;
minns=500000;

fullres = zeros(2040,8);
res=1;

while fin==0
    % Data reading
    [id,fin,nt,nrec,nprec,nsuc,dur,Prec,R,rec,opt]=reading(id,fin);
    
    tic
    
    % Activity list based on slacks
    S = SlackMethod(Prec, dur, nprec, nrec, rec, nt, R);
    ns = 1;
    
    % VND with four neighborhoods
    [S,ns,res,fullres] = VND(Prec, dur, nprec, nrec, rec, nt, R, S, ns, nvec, res, fullres, id, opt);
    fullres(id,res)=S.C;
    if ns>maxns
        maxns=ns;
        [id ns t]
    end
    if ns<minns
        minns=ns;
    end
    
    t=t+toc;
            
%             if met(7)==1
%                 [sol,solIn]=improvement(sol, solIn, Prec, nprec, dur, rec, R, nrec, nt);
%             end
%             %         [soluciones,inicio]=improvement_izq(soluciones, inicio, Prec, nprec, dur, rec, R, nrec, nt);
%             if met(8)==1
%                 [sol,solIn]=VND(sol, solIn, Prec, nprec, dur, rec, R, nrec, nt);
%             end
%             
%             
%             if sol(nt+1)<best(nt+1)
%                 best=sol;
%             end
%             
%             prom(sk)=prom(sk) + (best(nt+1) - opt) / opt;
% %         end
% %         
% %     end
%     prom(sk)=prom(sk)/10/sets*100;
% end
% 
% prom
% t=toc
% t/(480*3+600)

end
t
minns
t;