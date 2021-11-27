function [H,pmut]=crossover(P,p1,p2,nrk)

pto1=randi(nrk);
pto2=randi(nrk-pto1+1)+pto1-1;

H=P(p1);
H.RK(pto1:pto2) = P(p2).RK(pto1:pto2);

end