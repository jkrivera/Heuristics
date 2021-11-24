function [problem] = SeqGen(n,m,k)

E{1}=1:n;

i=ones(1,n);

s=0;
j=1;
while s<factorial(n)
    problem.Seq(s+1,j)=E{j}(i(j));
    if j<=n
        E{j+1}=E{j};
        E{j+1}(i(j))=[];
        i(j)=i(j)+1;
        i(j+1)=1;
        j=j+1;
    end
    if j==n+1
        s=s+1;
        if s==factorial(n)
            break;
        end
        problem.Seq(s+1,:)=problem.Seq(s,:);
        j=j-1;
        while i(j)==length(E{j})+1
            j=j-1;
        end
    end
end

for i=1:k
    s=s+1;
    problem.Seq(s,1)=0;
end

for i=1:m-1
    s=s+1;
    problem.Seq=[problem.Seq(1,:); problem.Seq(1,:); problem.Seq(2:end,:)];
end

problem.nrk=s;
problem.n=n;
problem.m=m;
problem.k=k;

end

