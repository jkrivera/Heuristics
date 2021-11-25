function h1 = MutationRK(h1,n)

i = randi(n-1)+1;
j = randi(n-1)+1;
while i == j
    j = randi(n-1)+1;
end

h1(i) = rand();
h1(j) = rand();

end