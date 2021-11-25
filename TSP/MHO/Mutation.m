function h1 = Mutation(h1,n)

i = randi(n-1)+1;
j = randi(n-1)+1;
while i == j
    j = randi(n-1)+1;
end

aux = h1(i);
h1(i) = h1(j);
h1(j) = aux;

end