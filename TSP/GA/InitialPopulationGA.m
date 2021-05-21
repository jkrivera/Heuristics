function [P,f] = InitialPopulation(n,d,npop)

R = rand(npop,n);

[~, P] = sort(R');
P = P';
P(:,end+1)=P(:,1);

f=zeros(1,npop);
for i = 1:npop
    for j = 1:n
        f(i) = f(i) + d(P(i,j),P(i,j+1));
    end
end

end