close all
%clear
%clc

% nacitanie dat, ci uz simulacia alebo hocico
v2_getData;
%parametre NARX
if upper == 0
    n=5;   % pocet minulych hondnot y
    m=5;   % pocet minulych hondnot u
    hn=100; % pocet skrytych neuronov
end

%% prepare save destination
path = strcat("all\",string(hn), "_", string(n), "_", string(m));
mkdir(path);


% vytvorenie NARX modelu
net = narxnet(1:m,1:n,hn);

% rozdelenie dat
net.divideFcn='divideind';
net.divideParam.trainInd = 1:lendiv2;
net.divideParam.testInd = lendiv2+1:length(u);

% trenovacie parametre
goal = 1e-3;
grad = 1e-10;

net.trainParam.epochs=500;
net.trainParam.goal=goal;
net.trainParam.min_grad = grad;
net.trainFcn = 'trainscg';
% vytvorenie posuvu vzoriek - all data
[X,Xi,Ai,Tr] = preparets(net,u,{},y);

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
printGraph(Tr1, YT1, 1, path, "U [V]");

% vytvorenie posuvu vzoriek - testovacie data
[X2,Xi,Ai,Tr2] = preparets(net,utest,{},ytest);

% simulacia vystupu modelu
YT2 = net(X2,Xi,Ai);

disp('------ chyba - testovacie data -------')
perf = perform(net,YT2,Tr2)
YT2_mat = cell2mat(YT2)';
Tr2_mat = cell2mat(Tr2)';
printGraph(Tr2, YT2, 2, path, "U [V]");

netc = closeloop(net);

[Xc,Xic,Aic,Tc] = preparets(netc,utest,{},ytest);
Yc = netc(Xc,Xic,Aic);
disp('------ chyba - testovacie data closed loop-------')
perfC = perform(netc,Yc,Tc)
YTC_mat = cell2mat(Yc)';
TrC_mat = cell2mat(Tc)';
printGraph(Tc, Yc, 3, path, "U [V]");

save(strcat(path,"\workspace.mat"),'net','netc','tr');