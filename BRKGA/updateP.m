function [P,worst,b,w,it] = updateP(P,H,npop,worst,b,w,bh)

check=zeros(1,npop);

if P(b).F >= H(bh).F
    b=w;
end

it=0;
while P(w).F >= H(bh).F
    it=it+1;
    P(w)=H(bh);
    check(bh)=1;
    w=0;
    bh=0;
    
    for i = 1:npop
        if w==0 || P(i).F>P(w).F
            w=i;
        end
        if check(i)~=1
            if bh==0 || H(i).F<H(bh).F
                bh=i;
            end
        end
    end
end

worst = P(w);

end