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
if upper == 0
n=2;   % pocet minulych hondnot y
m=2;   % pocet minulych hondnot u
hn=5; % pocet skrytych neuronov
end
u = transToCell(arrU');
yV = fullQout;
y = transToCell(yV');
goal = 1e3;


%% 
uall = u;
yall = y;
[trainMaxIndx,~] = size(trainBatt);

utrain= u(1:trainMaxIndx);
ytrain= y(1:trainMaxIndx);

utest = u(trainMaxIndx+1:length(u));
ytest = y(trainMaxIndx+1:length(y));