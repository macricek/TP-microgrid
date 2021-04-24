close all
clc
clear

global upper
upper = 1;

global n
global hn
global m

nAll = [1,4,7,10];
mAll = [1,4,7,10];
hnAll = [5,7,10,20,50];
bestPerfC = inf;
infoCell{1,1} = 'PathName';
infoCell{1,2} = 'Performance';
counter = 2;
for x1=1:length(nAll)
    for x2 = 1:length(mAll)
        for x3 = 1:length(hnAll)
            n = nAll(x1);
            m = mAll(x2);
            hn = hnAll(x3);
            arx_v1;
            
            if bestPerfC > perfC
                bestPerfC = perfC;
                bestPath = path;
            end
            infoCell{counter,1} = path;
            infoCell{counter,2} = perfC;
            counter = counter + 1;
        end
    end
end

