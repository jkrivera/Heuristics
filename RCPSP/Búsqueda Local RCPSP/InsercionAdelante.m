function [mejorVecino mejorInicio]=InsercionAdelante(soluciones, inicio, Prec, nt, nprec, duraciones, rec, predecesor, cantidadRecursos, nrec)

nuevoVecino=zeros(1,nt+1);
mejorVecino=zeros(1,nt+1);
mejorVecino(1,nt+1)=soluciones(1,nt+1)*10; %Inicializacion de la f.o. del mejor vecino

for i=3:(nt-1)
	condicion=1; %Recorrido del vector	
	j=i-1;
	while (condicion==1)
		if j==1
			condicion=0; %Ya recorrio todo el vector de soluciones, no hay cambio	
		else
			if Prec(soluciones(j),soluciones(i))==1
				condicion=0; %Hay restriccion de precedencia, no hay cambio
			else
				if inicio(soluciones(j))<inicio(soluciones(i)) %Hace el cambio si es buen movimiento
					nuevoVecino(1:j-1)=soluciones(1:j-1);
					nuevoVecino(j)=soluciones(i);
					nuevoVecino(j+1:i)=soluciones(j:i-1);
					nuevoVecino(i+1:nt)=soluciones(i+1:nt);
					[nuevoVecino inicioVecino]= makespan(nuevoVecino, Prec, nprec, duraciones, rec, predecesor, cantidadRecursos, nrec, nt);
					if nuevoVecino(nt+1)<mejorVecino(nt+1)
						mejorVecino=nuevoVecino; %Elige el mejor vecino
                        mejorInicio=inicioVecino;
					end
				end
			end
		end
		j=j-1;
	end
end