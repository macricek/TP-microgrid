close all
%clear

%% call from upper
global upper
if ~isempty(upper) && upper == 1
global n
global hn
global m
end
%% call v1 to get data
narx_prepareData;

%% prepare save destination
path = strcat("all\",string(hn), "_", string(n), "_", string(m));
mkdir(path);

% vytvorenie NARX modelu
net = narxnet(1:m,1:n,hn);

% rozdelenie dat
net.divideFcn='divideind';
net.divideParam.trainInd = 1:trainMaxIndx;
net.divideParam.testInd = trainMaxIndx+1:length(y);
net.divideParam.valInd=[];

% trenovacie parametre
net.trainParam.epochs=500;
net.trainParam.goal=goal;

% vytvorenie posuvu vzoriek - all data
[X,Xi,Ai,Tr] = preparets(net,uall,{},yall);

% trenovanie NARX modelu
[net,tr] = train(net,X,Tr,Xi,Ai);

% vytvorenie posuvu vzoriek - trenovacie data
[X1,Xi,Ai,Tr1] = preparets(net,utrain,{},ytrain);
% simulacia vystupu modelu
YT1 = net(X1,Xi,Ai);

%disp('------ chyba - trenovacie data -------')
perf = perform(net,YT1,Tr1);
YT1_mat = cell2mat(YT1)';
Tr1_mat = cell2mat(Tr1)';
printGraph(Tr1, YT1, 1, path, "P [W]");

% vytvorenie posuvu vzoriek - testovacie data
[X2,Xi,Ai,Tr2] = preparets(net,utest,{},ytest);

% simulacia vystupu modelu
YT2 = net(X2,Xi,Ai);

%disp('------ chyba - testovacie data -------')
perfT = perform(net,YT2,Tr2);
YT2_mat = cell2mat(YT2)';
Tr2_mat = cell2mat(Tr2)';
printGraph(Tr2, YT2, 2, path, "P [W]");

netc = closeloop(net);
[Xc,Xic,Aic,Tc] = preparets(netc,utest,{},ytest);
Yc = netc(Xc,Xic,Aic);
perfC = perform(netc,Yc,Tc);
disp(strcat(path," closed performace: ", string(perfC)));
YTC_mat = cell2mat(Yc)';
TrC_mat = cell2mat(Tc)';
printGraph(Tc, Yc, 3, path, "P [W]");

h4 = figure
plotperform(tr);
saveas(h4, strcat(path,"\perform.bmp"));


save(strcat(path,"\workspace.mat"),'net','netc','tr');