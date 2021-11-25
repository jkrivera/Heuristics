function f=FO(h,n,d)

f=0;
for i = 1:n
    f = f + d(h(i),h(i+1));
end

end