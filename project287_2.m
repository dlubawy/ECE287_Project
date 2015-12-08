clear x;
clear k;
k = 1;
for i=1:nrows
    if (mod(i,1474) == 0)
        x(k,1) = round((mean(y((i-1473):i,1),1) * 100000));
        k = k + 1;
    end
end