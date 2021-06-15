close all
out = 1;
v0_getData
uall=u;
yall=y;

if upper == 0
n=1;   % pocet minulych hondnot y
m=1;   % pocet minulych hondnot u
hn=5; % pocet skrytych neuronov
end
%% prepare save destination
path = strcat("all\",string(hn), "_", string(n), "_", string(m));
mkdir(path);

len = round(length(u));
lendiv2 = round(len/2);
% trenovacie data
utrain=u(1:lendiv2);
ytrain=y(1:lendiv2);

% testovacie data
utest=u(lendiv2+1:length(u));
ytest=y(lendiv2+1:length(y));

% vytvorenie NARX modelu
net = narxnet(1:m,1:n,hn);

% rozdelenie dat
net.divideFcn='divideind';
net.divideParam.trainInd=[1:lendiv2];
net.divideParam.testInd=[lendiv2+1:length(u)];
net.divideParam.valInd=[];

% trenovacie parametre
net.trainParam.epochs=500;
net.trainParam.goal=1e-15;
net.trainParam.min_grad = 1e-15;
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
printGraph(Tr1, YT1, 1, path, "f [Hz]");

% vytvorenie posuvu vzoriek - testovacie data
[X2,Xi,Ai,Tr2] = preparets(net,utest,{},ytest);

% simulacia vystupu modelu
YT2 = net(X2,Xi,Ai);

disp('------ chyba - testovacie data -------')
perf = perform(net,YT2,Tr2)
YT2_mat = cell2mat(YT2)';
Tr2_mat = cell2mat(Tr2)';
printGraph(Tr2, YT2, 2, path, "f [Hz]");

netc = closeloop(net);

[Xc,Xic,Aic,Tc] = preparets(netc,utest,{},ytest);
Yc = netc(Xc,Xic,Aic);
perfC = perform(netc,Yc,Tc);
disp(strcat(path," closed performace: ", string(perfC)));

printGraph(Tc, Yc, 3, path, "f [Hz]");

h4 = figure
plotperform(tr);
saveas(h4, strcat(path,"\perform.bmp"));

save(strcat(path,"\workspace.mat"),'net','netc','tr');