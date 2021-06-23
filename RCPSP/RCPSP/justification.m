function [justified fbi_inicio]=justification(soluciones, Prec, nprec, duraciones, rec, cantidadRecursos, nrec, nt, inicio)

fin=inicio+transpose(duraciones(:,2));

[x orden]=sort(fin,'descend');

for i1=1:nt-1
    for i2=i1+1:nt
        if fin(orden(i1))~=fin(orden(i2))
            break;
        end
    end
    i3=orden(i1);
    orden(i1)=orden(i2-1);
    orden(i2-1)=i3;
end

PrecFBI=transpose(Prec);
PrecFBI(1:nt,:)=PrecFBI(nt:-1:1,:);
PrecFBI(:,1:nt)=PrecFBI(:,nt:-1:1);

orden=nt-orden+1;

for i=1:nt
    nprecFBI(i)=sum(PrecFBI(:,i));%es un vector con nt componentes que indica el
    % numero de precedencias de cada actividad
end

[justified fbi_inicio]=makespan(orden, PrecFBI, nprecFBI, duraciones(nt:-1:1,:), rec(:,nt:-1:1), cantidadRecursos, nrec, nt);
justified(nt:-1:1)=nt-justified(1:nt)+1;
fbi_inicio(nt:-1:1)=justified(nt+1)-fbi_inicio(1:nt)-transpose(duraciones(nt:-1:1,2));

end