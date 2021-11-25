function [vec,fv] = RndNeighbor(n,d,sol,f)

i = randi(n-2,1,1);
while i==1
    i = randi(n-2,1,1);
end
j = randi(n,1,1);
while j<=i
    j = randi(n,1,1);
end

vec=sol;
for k=i:j
    vec(k)=sol(j+i-k);
end
fv=f-d(sol(i-1),sol(i))-d(sol(j),sol(j+1))+d(sol(i-1),sol(j))+d(sol(i),sol(j+1));

end