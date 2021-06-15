%% SU POTREBNE VSETKY ODSIMULOVANE DATA, kvoli velkosti nie su na gite! %%

clc
close all
clear
global upper
upper = 1;
global n
global hn
global m

v0_getData;
len = round(length(u));
lendiv2 = round(len/2);
% trenovacie data
utrain=u(1:lendiv2);
ytrain=y(1:lendiv2);

% testovacie data
utest=u(lendiv2+1:length(u));
ytest=y(lendiv2+1:length(y));

nAll = [1,4,7,10];
mAll = [1,4,7,10];
hnAll = [5,7,10,20];

bestPerfC = inf;
bestPerfO = inf;
bestPerfT = inf;
bestSetup = [1, 2, 3;  %closed
             1, 2, 3;  %opened
             1, 2, 3]; %training

infoCell{1,1} = 'PathName';
infoCell{1,2} = 'Performance closed';
infoCell{1,3} = 'Performance opened train';
infoCell{1,4} = 'Performance opened test';
counter = 2;
%%
for x1=1:length(nAll)
    for x2 = 1:length(mAll)
        for x3 = 1:length(hnAll)
            n = nAll(x1);
            m = mAll(x2);
            hn = hnAll(x3);
            
            path = strcat("all\",string(hn), "_", string(n), "_", string(m), "\workspace.mat");
            pathToFolder = strcat("all\",string(hn), "_", string(n), "_", string(m));
            
            load(path);
            [Xc,Xic,Aic,Tc] = preparets(netc,utest,{},ytest);
            Yc = netc(Xc,Xic,Aic);
            perfC = perform(netc,Yc,Tc);
            
            if bestPerfC >= perfC
                bestPerfC = perfC;
                bestPathC = pathToFolder;
                bestSetup(1,:) = [n, m, hn];
            end
            
            if bestPerfO >= tr.best_tperf
                bestPerfO = tr.best_tperf;
                bestPathO = pathToFolder;
                bestSetup(2,:) = [n, m, hn];
            end
            
            if bestPerfT >= tr.best_perf
                bestPerfT = tr.best_perf;
                bestPathT = pathToFolder;
                bestSetup(3,:) = [n, m, hn];
            end
            infoCell{counter,1} = pathToFolder;
            infoCell{counter,2} = perfC;
            infoCell{counter,3} = tr.best_perf;
            infoCell{counter,4} = tr.best_tperf;
            
            counter = counter + 1;
        end
    end
end


%% copy best models to dir
save('info','infoCell','bestPathO','bestPathC','bestPathT','bestSetup');
clear
load('info');
mkdir best\bestC
mkdir best\bestO
mkdir best\bestT
copyfile(bestPathC,"best\bestC");
copyfile(bestPathO,"best\bestO");
copyfile(bestPathT,"best\bestT");

%% show results
leg(1) = strcat("Best Closed: n= ", string(bestSetup(1,1)), ",m= ", string(bestSetup(1,2)), ",hn= ",string(bestSetup(1,3)));
leg(2) = strcat("Best Opened: n= ", string(bestSetup(2,1)), ",m= ", string(bestSetup(2,2)), ",hn= ",string(bestSetup(2,3)));
leg(3) = strcat("Best Train: n= ", string(bestSetup(3,1)), ",m= ", string(bestSetup(3,2)), ",hn= ",string(bestSetup(3,3)));

cd best
%% closed
cd bestC

open('closedf [Hz].fig')
hold on
title(strcat(leg(1),"[closed loop test]"));
saveas(gcf, 'closedf [Hz].bmp');

open('testf [Hz].fig')
hold on
title(strcat(leg(1),"[opened loop test]"));
saveas(gcf, 'testf [Hz].bmp');

open('trainf [Hz].fig')
hold on
title(strcat(leg(1),"[training data]"));
saveas(gcf, 'trainf [Hz].bmp');
% opened
cd ..
cd bestO
open('closedf [Hz].fig')
hold on
title(strcat(leg(2),"[closed loop test]"));
saveas(gcf, 'closedf [Hz].bmp');

open('testf [Hz].fig')
hold on
title(strcat(leg(2),"[opened loop test]"));
saveas(gcf, 'testf [Hz].bmp');

open('trainf [Hz].fig')
hold on
title(strcat(leg(2),"[training data]"));
saveas(gcf, 'trainf [Hz].bmp');
% train
cd ..
cd bestT
open('closedf [Hz].fig')
hold on
title(strcat(leg(3),"[closed loop test]"));
saveas(gcf, 'closedf [Hz].bmp');

open('testf [Hz].fig')
hold on
title(strcat(leg(3),"[opened loop test]"));
saveas(gcf, 'testf [Hz].bmp');

open('trainf [Hz].fig')
hold on
title(strcat(leg(3),"[training data]"));
saveas(gcf, 'trainf [Hz].bmp');