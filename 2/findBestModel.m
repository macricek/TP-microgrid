
%% SU POTREBNE VSETKY ODSIMULOVANE DATA, kvoli velkosti nie su na gite! %%



clc
close all
clear
global upper
upper = 1;
global n
global hn
global m
arx_prepareData;
nAll = [1,4,7,10];
mAll = [1,4,7,10];
hnAll = [5,7,10,20,50];
bestPerfC = inf;
infoCell{1,1} = 'PathName';
infoCell{1,2} = 'Performance closed';
infoCell{1,3} = 'Performance opened train';
infoCell{1,4} = 'Performance opened test';
counter = 2;
for x1=1:length(nAll)
    for x2 = 1:length(mAll)
        for x3 = 1:length(hnAll)
            n = nAll(x1);
            m = mAll(x2);
            hn = hnAll(x3);
            path = strcat("all\",string(hn), "_", string(n), "_", string(m), "\workspace.mat");
            pathToFolder = strcat("all\",string(hn), "_", string(n), "_", string(m));
            try
            load(path);
            [Xc,Xic,Aic,Tc] = preparets(netc,utest,{},ytest);
            Yc = netc(Xc,Xic,Aic);
            perfC = perform(netc,Yc,Tc);
            if bestPerfC > perfC
                bestPerfC = perfC;
                bestPath = pathToFolder;
            end
            infoCell{counter,1} = pathToFolder;
            infoCell{counter,2} = perfC;
            infoCell{counter,3} = tr.best_perf;
            infoCell{counter,4} = tr.best_tperf;
            counter = counter + 1;
            catch
            end
        end
    end
end
save('info','infoCell','bestPath','bestPerfC');

%% show
clear
load('info');
cd(bestPath);
train = imread('train.bmp');
test = imread('test.bmp');
perform = imread('perform.bmp');
closed = imread('closed.bmp');
figure
image(train);
figure
image(test);
figure
image(perform);
figure
image(closed);
cd ..
cd ..