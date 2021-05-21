function r=ranking(f,npop)

[~,srt]=sort(f);

r=zeros(1,npop);
h=0;
rank=1;
while h<npop
    for i=1:npop
        if r(srt(i))==0
            h=h+1;
            r(srt(i))=rank;
            p=i;
            break
        end
    end
    for i=1:npop
        if r(srt(i))==0
            if f(srt(i),2)<f(srt(p),2)
                h=h+1;
                r(srt(i))=rank;
                p=i;
            end
        end
    end
    rank=rank+1;
end

end