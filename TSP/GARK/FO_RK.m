function f1 = FO_RK(h1,npop,n,d)

[~, S] = sort(h1');
S = S';
S(end+1)=S(1);

f1=0;
for j = 1:n
    f1 = f1 + d(S(j),S(j+1));
end

end