function [p1,p2]=Tournament(npop,f)

s1 = randi(npop);
s2 = randi(npop);
while s2==s1
    s2 = randi(npop);
end
if f(s2)<f(s1)
    p1=s2;
else
    p1=s1;
end

s1 = randi(npop);
while s1==p1
    s1 = randi(npop);
end
s2 = randi(npop);
while s2==s1 || s2==p1
    s2 = randi(npop);
end
if f(s2)<f(s1)
    p2=s2;
else
    p2=s1;
end

end