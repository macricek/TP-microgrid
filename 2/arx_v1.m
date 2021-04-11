close all
clc
clear

%% call v1 to get data
simulation = 0;
plotData = 0;
v1;

%% parse data to training and testing set
trainingVector = [1,2,4,5,7];
testingVector = [3,6];

trainBatt = pickDay(batteryIn,trainingVector);
trainCharger = pickDay(chargerIn,trainingVector);
trainSolar = pickDay(solarIn,trainingVector);
trainVarload = pickDay(variableLoadIn,trainingVector);
trainWind = pickDay(windIn,trainingVector);
trainPout = pickDay(POut,trainingVector);
trainQout = pickDay(QOut,trainingVector);

testBatt = pickDay(batteryIn,testingVector);
testCharger = pickDay(chargerIn,testingVector);
testSolar = pickDay(solarIn,testingVector);
testVarload = pickDay(variableLoadIn,testingVector);
testWind = pickDay(windIn,testingVector);
testPout = pickDay(POut,testingVector);
testQout = pickDay(QOut,testingVector);

fullBatt = [trainBatt; testBatt];
fullCharger = [trainCharger; testCharger];
fullSolar = [trainSolar; testSolar];
fullVarload = [trainVarload; testVarload];
fullWind = [trainWind; testWind];
fullPout = [trainPout; testPout];
fullQout = [trainQout; testQout];

arrU = [fullBatt,fullCharger,fullSolar,fullVarload,fullWind];
%% prepare dataset for NARX U
n=4;   % pocet minulych hondnot y
m=4;   % pocet minulych hondnot u
hn=100; % pocet skrytych neuronov

u = transToCell(arrU');
yV = fullQout;
y = transToCell(yV');
goal = 1e3;

%% prepare save destination
path = string(hn);
mkdir(path);
%% 
uall = u;
yall = y;
[trainMaxIndx,~] = size(trainBatt);

utrain= u(1:trainMaxIndx);
ytrain= y(1:trainMaxIndx);

utest = u(trainMaxIndx+1:length(u));
ytest = y(trainMaxIndx+1:length(y));

% vytvorenie NARX modelu
net = narxnet(1:m,1:n,hn);

% rozdelenie dat
net.divideFcn='divideind';
net.divideParam.trainInd = 1:trainMaxIndx;
net.divideParam.testInd = trainMaxIndx+1:length(y);
net.divideParam.valInd=[];

% trenovacie parametre
net.trainParam.epochs=10000;
net.trainParam.goal=goal;
%net.trainParam.min_grad = grad;
%net.trainFcn = 'trainscg';
% vytvorenie posuvu vzoriek - all data
[X,Xi,Ai,Tr] = preparets(net,uall,{},yall);

% trenovanie NARX modelu
[net,tr] = train(net,X,Tr,Xi,Ai);

% vytvorenie posuvu vzoriek - trenovacie data
[X1,Xi,Ai,Tr1] = preparets(net,utrain,{},ytrain);
%% TODO transpozicia na grafy
% simulacia vystupu modelu
YT1 = net(X1,Xi,Ai);

disp('------ chyba - trenovacie data -------')
perf = perform(net,YT1,Tr1)
YT1_mat = cell2mat(YT1)';
Tr1_mat = cell2mat(Tr1)';

h1 = figure
plot(YT1_mat)
hold on
plot(Tr1_mat,'r')
title('Trenovacie data')
xlabel('vzorky')
legend('NARX','Data')
saveas(h1, strcat(path,"\train.bmp"));

% vytvorenie posuvu vzoriek - testovacie data
[X2,Xi,Ai,Tr2] = preparets(net,utest,{},ytest);

% simulacia vystupu modelu
YT2 = net(X2,Xi,Ai);

disp('------ chyba - testovacie data -------')
perf = perform(net,YT2,Tr2)
YT2_mat = cell2mat(YT2)';
Tr2_mat = cell2mat(Tr2)';

h2 = figure
plot(YT2_mat)
hold on
plot(Tr2_mat,'r')
title('Testovacie data')
xlabel('vzorky')
legend('NARX','Data')
saveas(h2, strcat(path,"\test.bmp"));
netc = closeloop(net);

[Xc,Xic,Aic,Tc] = preparets(netc,utest,{},ytest);
Yc = netc(Xc,Xic,Aic);
YTC_mat = cell2mat(Yc)';
TrC_mat = cell2mat(Tc)';

h3 = figure
plot(YTC_mat)
hold on
plot(TrC_mat,'g')
title('Testovacie Close Loop data')
xlabel('vzorky')
legend('NARX','Data')
saveas(h3, strcat(path,"\closed.bmp"));

h4 = figure
plotperform(tr);
saveas(h4, strcat(path,"\perform.bmp"));

h5 = figure
plotresponse(tr);
saveas(h5, strcat(path,"\response.bmp"));

save(strcat(path,"\workspace.mat"));