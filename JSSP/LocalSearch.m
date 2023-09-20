function [Sol,it] = LocalSearch(n,m,P,Rec,Sol)

it = 0;
stop = 0;

while stop == 0
    it=it+1;
    stop = 1;

    for i = 1:n*m
        for j = i+1:n*m
            Vec = Interchange(n,m,P,Rec,Sol,i,j);
            if Vec.Cmax < Sol.Cmax
                Sol = Vec;
                stop = 0;
                break;
            end
        end
        if stop==0
            break;
        end
    end

end

end