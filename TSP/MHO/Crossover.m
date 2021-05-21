function [h1,h2] = Crossover(P,npop,n,x,y)

l = randi(n-3);
p1= randi(n-l)+1;
p2=p1+l;

h1 = zeros(1,n+1);
h2 = zeros(1,n+1);

h1(1:p1) = P(x,1:p1);
h1(p2:n+1) = P(x,p2:n+1);

check=zeros(1,n+1);
check(h1(1:p1))=1;
check(h1(p2+1:n+1))=1;

j=p1+1;
for i = 1:n
    if check(P(y,i))==0
        h1(j)=P(y,i);
        j=j+1;
    end
end

h2(1:p1) = P(y,1:p1);
h2(p2:n+1) = P(y,p2:n+1);

check=zeros(1,n+1);
check(h2(1:p1))=1;
check(h2(p2+1:n+1))=1;

j=p1+1;
for i = 1:n
    if check(P(x,i))==0
        h2(j)=P(x,i);
        j=j+1;
    end
end

% h1 = [P(x,1:p1) P(y,p1+1:p2) P(x,p2+1:n+1)];
% h2 = [P(y,1:p1) P(x,p1+1:p2) P(y,p2+1:n+1)];

end