uall=u;
yall=y;

% trenovacie data
utrain=u(1:5000);
ytrain=y(1:5000);

% testovacie data
utest=u(5001:length(u));
ytest=y(5001:length(y));

% vytvorenie NARX modelu
net = narxnet(1:m,1:n,hn);

% rozdelenie dat
net.divideFcn='divideind';
net.divideParam.trainInd=[1:5000];
net.divideParam.testInd=[5001:length(y)];
net.divideParam.valInd=[];

% trenovacie parametre
net.trainParam.epochs=500;
net.trainParam.goal=goal;
net.trainParam.min_grad = grad;
%net.trainFcn = 'trainscg';
% vytvorenie posuvu vzoriek - all data
[X,Xi,Ai,Tr] = preparets(net,uall,{},yall);

% trenovanie NARX modelu
net = train(net,X,Tr,Xi,Ai);

% vytvorenie posuvu vzoriek - trenovacie data
[X1,Xi,Ai,Tr1] = preparets(net,utrain,{},ytrain);
%% TODO transpozicia na grafy
% simulacia vystupu modelu
YT1 = net(X1,Xi,Ai);

disp('------ chyba - trenovacie data -------')
perf = perform(net,YT1,Tr1)
YT1_mat = cell2mat(YT1)';
Tr1_mat = cell2mat(Tr1)';

figure
plot(YT1_mat)
hold on
plot(Tr1_mat,'r')
title('Trenovacie data')
xlabel('vzorky')
legend('NARX','Data')

% vytvorenie posuvu vzoriek - testovacie data
[X2,Xi,Ai,Tr2] = preparets(net,utest,{},ytest);

% simulacia vystupu modelu
YT2 = net(X2,Xi,Ai);

disp('------ chyba - testovacie data -------')
perf = perform(net,YT2,Tr2)
YT2_mat = cell2mat(YT2)';
Tr2_mat = cell2mat(Tr2)';

figure
plot(YT2_mat)
hold on
plot(Tr2_mat,'r')
title('Testovacie data')
xlabel('vzorky')
legend('NARX','Data')

netc = closeloop(net);

[Xc,Xic,Aic,Tc] = preparets(netc,utest,{},ytest);
Yc = netc(Xc,Xic,Aic);
YTC_mat = cell2mat(Yc)';
TrC_mat = cell2mat(Tc)';

figure
plot(YTC_mat)
hold on
plot(TrC_mat,'g')
title('Testovacie Close Loop data')
xlabel('vzorky')
legend('NARX','Data')
% gensim(net,T)
% 
% gensim(netc,T)