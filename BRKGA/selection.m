function [p1,p2]=selection(P,npop,b,w)

r1 = randi(npop);
while P(r1).F > ceil(0.4*(P(w).F-P(b).F)+P(b).F)
    r1 = randi(npop);
end
r2 = randi(npop);
while r1==r2
    r2 = randi(npop);
end
if P(r1).F <= P(r2).F
    p1=r1;
else
    p1=r2;
end

r1 = randi(npop);
r2 = randi(npop);
while r1==p1
    r1 = randi(npop);
end
while r1==r2 || r2==p1
    r2 = randi(npop);
end
if P(r1).F <= P(r2).F
    p2=r1;
else
    p2=r2;
end

end