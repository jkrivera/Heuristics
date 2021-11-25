function [p1,p2]=Selection(r,npop)

a = randi(npop);
b = randi(npop);
while a==b
    b = randi(npop);
end
if r(a)>r(b)
    p1=b;
else
    p1=a;
end

a = randi(npop);
while a==p1
    a = randi(npop);
end
b = randi(npop);
while a==b || b==p1
    b = randi(npop);
end
if r(a)>r(b)
    p2=b;
else
    p2=a;
end

end