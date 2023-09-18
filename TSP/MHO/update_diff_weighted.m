function [H,fh] = update_diff_weighted(P,f,npop,n)

check = zeros(1,length(f));

[fh,sel] = min(f);
check(sel) = 1;
dist = ones(1,length(f))*inf;

for p = 2:npop
    for i = 1:length(f)
        if check(i) == 0
            aux = 0;
            for v = 1:n
                aux = aux + (P(sel(end),v)-P(i,v))^2;
            end
            if aux < dist(i)
                dist(i) = aux;
            end
            w(i) = 0.4 * (f(i)-min(f))/(max(f)-min(f)) + 0.6 * (max(dist.*(1-check))-dist(i))/(max(dist.*(1-check))-min(dist));
        else
            w(i) = inf;
        end
    end
    [a,b] = min(w);
    sel(end+1) = b;
    check(b) = 1;
end

H = P(sel,:);
fh = f(sel);

end