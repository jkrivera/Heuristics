function sol=Mutacion(RK,y,n)

t=randi(3);
for i = 1:t
    rn=randi(n);
    RK(y,rn)=rand;
end
sol=RK(y,:);

end