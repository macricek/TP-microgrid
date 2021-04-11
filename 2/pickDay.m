function data = pickDay(in, vector)
    data = [];
    for i=1:length(vector)
        data = [data;in(:,vector(i))];
    end
end