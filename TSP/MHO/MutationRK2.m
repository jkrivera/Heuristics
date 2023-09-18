function h1 = MutationRK2(h1,n,d)
npop=1;
f = distanceRK(h1,npop,n,d);
for m = 1 : 5
    i = randi(n-1)+1;
    h1(i) = rand();
    f1 = distanceRK(h1,npop,n,d);
    if f1 < f
        break
    end
end

end