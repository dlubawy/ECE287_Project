clear y;
[y, Fs, nbits, readinfo] = wavread('25-C2');
[nrows,ncols] = size(y);
for i = 1:nrows
    y(i,1) = round((y(i,1)/0.2595),3) * 10;
end

% for row = 1:nrows
% fprintf(fileID,['17''d' num2str(row) ':begin\n\tsound <= 32''d1000000 * %d;\n\tS <= 17''d' num2str(row+1) ';\nend\n'],y(row,1));
% end