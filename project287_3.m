j = 1:256;
for z=j
    if x(z,1)<0
        x(z,1) = 2^16 + x(z,1);
    end
    fprintf('\t\t\t8''h%02x: sine = 16''h%04x ;\n', j(z)-1 ,x(z,1)) 
    s(z,1) = x(z,1);
end