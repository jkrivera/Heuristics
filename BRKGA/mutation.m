function H = mutation(H,nrk)

r=randi(max(1,ceil(nrk*0.01)));

for i = 1:r
    d=randi(nrk);
    H.RK(d)=rand;
end

end