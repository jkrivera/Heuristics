function f=objectives(P,n,d,npop)

f=zeros(npop,2);
for i=1:npop
    for j=1:n
        f(i,1)=f(i,1)+d(P(i,j),P(i,j+1));
        f(i,2)=f(i,2)+(n+1-j)*d(P(i,j),P(i,j+1));
    end
end

end