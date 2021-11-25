function [x,y] = Tournament(npop,f)

c1 = randi(npop);
c2 = randi(npop);
while c2==c1
    c2 = randi(npop);
end

if f(c1)<=f(c2)
    x = c1;
else
    x = c2;
end

c3 = randi(npop);
c4 = randi(npop);
while c3==c1 || c3==c2
    c3 = randi(npop);
end
while c4==c1 || c4==c2 || c4==c3
    c4 = randi(npop);
end

if f(c3)<=f(c4)
    y = c3;
else
    y = c4;
end

end