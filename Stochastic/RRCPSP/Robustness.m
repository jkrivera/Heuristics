function Sol = Robustness(Sol,h,n,m,dur,P,nprec,suc,prec,R,rec)

Sol(h).R = 0;
Sol(h).Rn = 0;

for i = 2 : n-1
    fin = 0;
    t = 1;
    while fin == 0
        for j = 1 : suc(Sol(h).S(i),1)
            if Sol(h).St(Sol(h).S(i)) + dur(Sol(h).S(i)) + t > Sol(h).St(suc(Sol(h).S(i),j+1))
                fin = 1;
                t = t-1;
                break;
            end
        end
        if fin==0
            for k = 1:m
                if Sol(h).rectime(k,Sol(h).St(Sol(h).S(i)) + dur(Sol(h).S(i))+t) + rec(k,Sol(h).S(i)) > R(k)
                    fin=1;
                    t = t-1;
                    break;
                end
            end
        end
        if fin==0
            t=t+1;
        end
    end
    if t>0
        Sol(h).R = Sol(h).R + t;
        Sol(h).Rn = Sol(h).Rn + 1;
    end
end

end