function [mejor,iniciom]=improvement(soluciones, inicio, Prec, nprec, dur, rec, R, nrec, nt)

% toprint='';

iniciom=inicio;
mejor=soluciones;
% for h=1:nt+1
%     toprint = [toprint mat2str(soluciones(h)) ' '];
% end

stop=0;

while stop==0
    stop=1;
    for i=2:nt-1
        for j=i+1:nt-1
            if Prec(soluciones(i),soluciones(j))==0
                if inicio(soluciones(i))<inicio(soluciones(j))
                    vecino=soluciones;
                    for k=i+1:j
                        vecino(k-1)=soluciones(k);
                    end
                    vecino(j)=soluciones(i);

                    vecino(1,nt+1)=0;
                    [vecino,iniciov]=makespan(vecino, Prec, nprec, dur, rec, R, nrec, nt);
    %                 toprint2='';
    %                 for h=1:nt+1
    %                     toprint2 = [toprint2 mat2str(vecino(h)) ' '];
    %                 end
    %                 toprint=[toprint;toprint2];

                    if mejor(nt+1) > vecino(nt+1)
                        stop=0;
                        mejor = vecino;
                        iniciom=iniciov;
                    end
                end
            else
                break
            end

        end
    end
%     mejor(nt+1)
    soluciones=mejor;
%     toprint
end

end