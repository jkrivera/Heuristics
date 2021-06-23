function [S,ns,res,fullres] = VND(Prec, dur, nprec, nrec, rec, nt, R, S, ns, k, res, fullres, id, opt)

% Start from the first neighborhood
vec=1;

while vec <= k
    if vec==1
        % Insertion to right
        [Sp,ns,res,fullres]=N1(Prec, dur, nprec, nrec, rec, nt, R, S, ns, res, fullres, id, opt);
        if Sp.C < S.C
            S = Sp;
            vec = 1;
        else
            vec = vec+1;
        end
    else
        if vec==2
            % Insertion to left
            [Sp,ns,res,fullres]=N2(Prec, dur, nprec, nrec, rec, nt, R, S, ns, res, fullres, id, opt);
            if Sp.C < S.C
                S = Sp;
                vec = 1;
            else
                vec = vec+1;
            end
        else
            if vec==3
                % Interchange
                [Sp,ns,res,fullres]=N3(Prec, dur, nprec, nrec, rec, nt, R, S, ns, res, fullres, id, opt);
                if Sp.C < S.C
                    S = Sp;
                    vec = 1;
                else
                    vec = vec+1;
                end
            else
                if vec==4
                    % L-Interchange
                    [Sp,ns,res,fullres]=N4(Prec, dur, nprec, nrec, rec, nt, R, S, ns, res, fullres, id, opt);
                    if Sp.C < S.C
                        S = Sp;
                        vec = 1;
                    else
                        vec = vec+1;
                    end
                end
            end
        end
    end
    if res>8
        break
    end
end

end