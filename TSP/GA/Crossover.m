function [h1,h2]=Crossover(P,p1,p2,n)

pc = randi(n-2)+1;

h1 = zeros(1,n+1);
h1(1:pc) = P(p1,1:pc);
check = zeros(1,n);
check(h1(1:pc))=1;
h=pc;
for i = 1:n
    if check(P(p2,i))==0
        h=h+1;
        h1(h)=P(p2,i);
    end
end
h1(n+1)=h1(1);

h2 = zeros(1,n+1);
h2(1:pc) = P(p2,1:pc);
check = zeros(1,n);
check(h2(1:pc))=1;
h=pc;
for i = 1:n
    if check(P(p1,i))==0
        h=h+1;
        h2(h)=P(p1,i);
    end
end
h2(n+1)=h2(1);

end