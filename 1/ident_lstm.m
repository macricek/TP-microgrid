% identifikacia nelinearneho systemu - NARX model

clear
v0_getData
n=4;   % pocet minulych hondnot y
m=4;   % pocet minulych hondnot u
hn=10; % pocet skrytych neuronov
T=1; % perioda vzorkovania

u = [batteryPref,varLoad];
y = P;

% vsetky data
% uall=num2cell(u');
% yall=num2cell(y');
uall=u';
yall=y';

% mu1 = mean(uall);
% sig1 = std(uall);
% uall = (uall - mu1) / sig1;
% 
% mu2 = mean(yall);
% sig2 = std(yall);
% yall = (yall - mu2) / sig2;

% trenovacie data
utrain=uall(:,1:5000);
ytrain=yall(1:5000);

% testovacie data
utest=uall(:,5001:length(y));
ytest=yall(5001:length(y));

% vytvorenie NARX modelu
numFeatures = 2;
numResponses = 1;
numHiddenUnits = 50;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',250, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');


% trenovanie NARX modelu
net = trainNetwork(utrain,ytrain,layers,options);

% simulacia vystupu modelu
[net,yp1] = predictAndUpdateState(net,utrain);

yp2 = predict(net,utest);

disp('------ chyba - trenovacie data -------')
% perf = perform(net,yp1,ytrain)
SSE1=sum((yp1-ytrain).^2)/5000;

figure
plot(yp1)
hold on
plot(ytrain,'r+')
title('Trenovacie data')
xlabel('vzorky')
legend('LSTM','Data')


disp('------ chyba - testovacie data -------')
% perf = perform(net,yp2,ytest)
SSE2=sum((yp2-ytest).^2)/5000;

figure
plot(yp2)
hold on
plot(ytest,'r+')
title('Testovacie data')
xlabel('vzorky')
legend('LSTM','Data')

