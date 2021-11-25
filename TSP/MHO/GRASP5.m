function [best,fb] = GRASP5(n,d,tmax)

Ms=zeros(n,n);
for k=1:n
    [~,Ms(k,1:n)]=sort(d(k,:));
end
% Ms(:,1)=[];

tic
fb=Inf;
% while toc< tmax
for it = 1:tmax
%     [sol,f] = constr_rand(n,d,3);
    [sol,f,pos] = constr_rand_2(n,d,Ms,3);
    [sol,f] = FastLS(n,d,sol,f);
    if f<fb
        fb=f;
        best=sol;
    end
end

end