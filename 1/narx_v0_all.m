clc
clear
close all


Ts = 1;
upper = 1;
nAll = [1,4,7,10];
mAll = [1,4,7,10];
hnAll = [5,7,10,20];
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
            narx_v0;
            
            if bestPerfC > perfC
                bestPerfC = perfC;
                bestPath = path;
            end
            infoCell{counter,1} = path;
            infoCell{counter,2} = perfC;
            counter = counter + 1;
        end
        pause(10*60);
    end
    pause(20*60);
end