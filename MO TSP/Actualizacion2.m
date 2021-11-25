function [RK,P,f,r]=Actualizacion2(RK,P,f,nc,r,npop)

m=max(r);

h=nc;
while nc>npop-10
    i=0;
    while i<nc
        i=i+1;
        if r(i)==m
            RK(i,:)=[];
            P(i,:)=[];
            f(i,:)=[];
            r(i)=[];
            nc=nc-1;
            if nc==npop-10
                break
            end
        end
    end
    m=max(r);
end

end