function [h1,h2] = CrossoverRK(P,npop,n,x,y)

l = randi(n-5);
p1= randi(n-5)+2;
p2=p1+l;
if p2>=n
    p2=n-1;
end

h1 = [P(x,1:p1-1) P(y,p1:p2) P(x,p2+1:n)];
h2 = [P(y,1:p1-1) P(x,p1:p2) P(y,p2+1:n)];

end