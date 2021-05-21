function [h1,h2]=CrossoverRK(P,p1,p2,n)

pc = randi(n-2)+1;

h1 = [P(p1,1:pc) P(p2,pc+1:n)];

h2 = [P(p2,1:pc) P(p1,pc+1:n)];

end