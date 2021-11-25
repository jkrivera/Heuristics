function [P,f] = InitialPopulationRK(n,d,npop)

P = rand(npop,n);

[~, S] = sort(P');
S = S';
S(:,end+1)=S(:,1);

f=zeros(1,npop);
for i = 1:npop
    for j = 1:n
        f(i) = f(i) + d(S(i,j),S(i,j+1));
    end
end

end