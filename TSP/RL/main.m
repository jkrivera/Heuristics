%clear
clc
format 'bank';
p=1;
[n,d] = readingTSP(1);

% Parameters
alpha = 0.1;
gamma = 0.9;
epsilon = 0.1;
maxit = 1000000;

Q = -alpha*d;

Zb = Inf;
Solb = [];
Zt = [];

for it = 1:maxit
    % Initial state (always the same?)
    s=1;
    check = zeros(1,n);
    check(1) = 1;
    Sol = 1;
    Z = 0;
    while sum(check) < n
        v = max(Q(s,find(check==0)));
        if rand > epsilon
            % chose action with largest Q value
            a = find(Q(s,:) == v);
            b = find(check==1);
            for j = b(end:-1:1)
                for i = a(end:-1:1)
                    if i==j
                        a(find(a==i))=[];
                        break
                    end
                end
            end
        else
            a = find(check~=1);
        end
        if length(a) > 1
            r = randi(length(a));
            a = a(r);
        end
        Sol(length(Sol)+1) = a;
        check(a)=1;
        if sum(check) == n
%             Q(s,a) = Q(s,a) + alpha*(-d(s,a)+gamma*max(Q(a,Sol(1)))-Q(s,a));
            Q(s,a) = Q(s,a) + alpha*(-d(s,a)+gamma*max(Q(a,:))-Q(s,a));
        else
%             Q(s,a) = Q(s,a) + alpha*(-d(s,a)+gamma*max(Q(a,find(check==0)))-Q(s,a));
            Q(s,a) = Q(s,a) + alpha*(-d(s,a)+gamma*max(Q(a,:))-Q(s,a));
        end
        Sol;
        Z = Z + d(s,a);
        s=a;
    end
    a = Sol(1);
    Q(s,a) = Q(s,a) + alpha*(-d(s,a)+gamma*max(Q(a,:))-Q(s,a));
    Sol(length(Sol)+1) = Sol(1);
    Z = Z + d(s,a);
    
    Zt = [Zt Z];
    
    if Z<Zb
        Zb = Z;
        Solb = Sol;
        [it Zb]
    end
end
Q