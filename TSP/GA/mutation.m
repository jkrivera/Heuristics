function h = mutation(h,n)

s1 = randi(n-1)+1;
s2 = randi(n-1)+1;
while s1==s2
    s2 = randi(n-1)+1;
end

aux = h(s1);
h(s1)=h(s2);
h(s2)=aux;

end