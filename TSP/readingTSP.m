function [n,d]=readingTSP(id)

if id==1
    sheet='burma14';
elseif id==2
    sheet='ch150';
elseif id==3
    sheet='dsj1000';
elseif id==4
    sheet='brd14051';
end
num = xlsread('TSP.xlsm',sheet);

n=num(1,1);
num(1,:)=[];

d=zeros(n,n);
for i = 1:n
    for j = i+1:n
        d(i,j)=sqrt((num(i,2)-num(j,2))^2+(num(i,3)-num(j,3))^2);
        d(j,i)=d(i,j);
    end
end

end