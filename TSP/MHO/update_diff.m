function [H,fh] = update_diff(P,f,npop,n)

check = zeros(1,length(f));

[fh,sel] = min(f);
check(sel) = 1;
dist = ones(1,length(f))*inf;

for p = 2:npop
    cand = -1;
    for i = 1:length(f)
        if check(i) == 0
            aux = 0;
            for v = 1:n
                aux = aux + (P(sel(end),v)-P(i,v))^2;
            end
            if aux < dist(i)
                dist(i) = aux;
            end
            if cand == -1 || dist(i) > dist(cand)
                cand = i;
            end
        end
    end
    sel(end+1) = cand;
    check(cand) = 1;
end

H = P(sel,:);
fh = f(sel);

end


