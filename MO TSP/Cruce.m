function [h1,h2]=Cruce(RK,p1,p2,n)

t1=1+randi(n-2);
h1=[RK(p1,1:t1),RK(p2,t1+1:end)];
h2=[RK(p2,1:t1),RK(p1,t1+1:end)];

end