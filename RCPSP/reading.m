function [id,fin,nt,nrec,nprec,nsuc,dur,Prec,R,rec,opt] = reading(id,fin)
%% Reading
% [id,fin,nt,nrec,dur,Prec,R,rec,opt] = reading(id)
% id: index of activity (from 1 to 2040).
% fin: 1 if id activity is the last one.
% nt: number of activities
% nrec: number of resources
% nprec: number of precedences of each activity
% nsuc: number of successors of each activity
% dur: activity durations
% Prec: precedence relationships. Prec=1 if activity i precedes activity j
% R: resource capacities
% rec: resource consumption. Number of resources that activity i requires from resource j.
% opt: optimal or best known solution of problem id

id=id+1;

% Define the size of the problem
if id <= 480
    sk=1;
    sets=48;
    txt='3';
elseif id <= 960
    sk=2;
    sets=48;
    txt='6';
elseif id <= 1440
    sk=3;
    sets=48;
    txt='9';
else
    sk=4;
    sets=60;
    txt='12';
end

% Last instance
if id == 480*3+600
    fin=1;
end

% si index definition
if id <= 480
    si=ceil(id/10);
elseif id <= 960
    si=ceil((id-480)/10);
elseif id <= 960+480
    si=ceil((id-960)/10);
else
    si=ceil((id-1440)/10);
end

% sj index definition
if id <= 480
    sj=id-(si-1)*10;
elseif id <= 960
    sj=id-480-(si-1)*10;
elseif id <= 960+480
    sj=id-960-(si-1)*10;
else
    sj=id-1440-(si-1)*10;
end

%[sk si sj]

% Activity durations
dur=['Datos' txt '0/dura' num2str(si) num2str(sj) '.txt']; % (Act. - Dur.)
dur=textread(dur);
dur=dur(:,2);

% Number of activities
nt=length(dur);

% Resource consumption
recu=['Datos' txt '0/core' num2str(si) num2str(sj) '.txt']; % (Rec. - Act. - Cons.)
recu=textread(recu);
for i = 1:length(recu)
    rec(recu(i,1),recu(i,2))=recu(i,3);
end


% Number of resources
nrec=length(recu)/nt;

% Precedence relationships
pred=['Datos' txt '0/pred' num2str(si) num2str(sj) '.txt']; % (Pred. Act. - Succ. Act.)
pred=textread(pred); %pred
Prec=zeros(nt,nt);            
for i=1:size(pred,1)
    Prec(pred(i,1),pred(i,2))=1;
end

% Number of precedences
nprec=sum(Prec);

% Number of successors
nsuc=sum(Prec,2)';

% Resource capacity
R=['Datos' txt '0/recu' num2str(si) num2str(sj) '.txt']; % (Rec. - Cap.)
R=textread(R);  %recu
R=R(:,2);
    
% Optimal or best known solutions
opt=['Datos' txt '0/OPTIMOS' txt '2.txt'];
opt=textread(opt);
opt=opt(:,2);
opt=opt((si-1)*10+sj);

end