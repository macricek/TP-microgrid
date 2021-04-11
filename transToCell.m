function cellOut = transToCell(in)
%% transform matrix to cell -> for NARX purposes
[a,b] = size(in);
cellOut = {};
for i=1:b
    vekt = [];
    for j = 1:a
        vekt = [vekt;in(j,i)];
    end
    cellOut{1,i} = vekt;
end
end