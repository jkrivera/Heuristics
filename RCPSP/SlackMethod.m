function [S]=SlackMethod(Prec, dur, nprec, nrec, rec, nt, R)
S.sol=zeros(1,nt); % Activity list
check=zeros(1,nt); % 1 if an activity has been scheduled

% First activity
S.sol(1)=1;
check(1)=1;

ES=zeros(1,nt);
EF=zeros(1,nt);
LF=zeros(1,nt);
LS=zeros(1,nt);

nprec2=Prec(1,:);

ne=0;
elegible=zeros(1,nt/2-1);
for i=2:nt
    if Prec(1,i)==1
        ne=ne+1;
        elegible(ne)=i;
    end
end
%elegible=find(nprec2(2:nt-1)==nprec(2:nt-1))+1;

cumres=zeros(nrec,sum(dur));

% For each position in the activity list vector
for i=2:nt-1 %Se va construyendo el vector Solucion
    
    %compute the early start and the early finish
    for j=2:nt
        if check(j)~=1
            ES(j)=max(EF.*Prec(:,j)');
            EF(j)=ES(j)+dur(j);
        end
    end
    
    %compute the late start and late finish
    LF(nt)=EF(nt);
    LS(nt)=LF(nt)-dur(nt);
    for j=nt-1:-1:2
        if check(j)~=1
            LF(j)=min(LS(Prec(j,:)~=0));
            LS(j)=LF(j)-dur(j);
        end
    end
    
    % Slack computation
    Slack=LF-EF;
    
    % Elegible activity with minimum slack
    [~,e]=min(Slack(elegible(1:ne)));
    %[~,e]=min(Slack(elegible));
    e=elegible(e);
    
    % Are there enoguh resources?
    t=ES(e)+1;
    while t<=ES(e)+dur(e)
        for r=1:nrec
            if cumres(r,t)+rec(r,e)>R(r)
                ES(e)=t; %if not, increase starting time
                break;
            end
        end
        t=t+1;
    end
    
    % Compute new ES, EF, LS, LF values
    EF(e)=ES(e)+dur(e);
    LS(e)=ES(e);
    LF(e)=EF(e);
    
    % Update reqired resources
    for t=ES(e)+1:EF(e)
        for r=1:nrec
            cumres(r,t)=cumres(r,t)+rec(r,e);
        end
    end
    
    %Update assigned activities
    check(e)=1;
    
    % Update number of used precedences
    nprec2=nprec2+Prec(e,:);
    
    % Update elegible activities
    f=find(elegible==e);
    %elegible=elegible(elegible~=e);
    elegible(f)=elegible(ne);
    ne=ne-1;
    for j=2:nt
        if Prec(e,j)==1
            if nprec(j)==nprec2(j)
                ne=ne+1;
                elegible(ne)=j;
            end
        end
    end
    
    % Add activity to the list
    S.sol(i)=e;
    
end
S.sol(nt)=nt;

ES(nt)=max(EF.*Prec(:,nt)');

% Solution cost
S.C=ES(nt)+dur(nt);
% Starting times
S.St = ES;

end