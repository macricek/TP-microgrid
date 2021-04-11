% clc
% clear
% close all

if exist('simulation','var') == 0
simulation = 1;
end

if simulation
%% in:
    batteryIn = [];
    chargerIn = [];
    solarIn = [];
    variableLoadIn = [];
    windIn = [];
    T = [];
%% out:
    POut = [];
    QOut = [];
    load('v2gdata.mat');
    open('simpleMicrogrid_v1.slx');
    for i=1:7
        sim('simpleMicrogrid_v1.slx');
        batteryIn =     [batteryIn, battery_in];
        chargerIn =     [chargerIn, charger_in];
        solarIn =       [solarIn, solar_in];
        variableLoadIn =[variableLoadIn, variableLoad_in];
        windIn =        [windIn, wind_in];
        P_out(1) = P_out(2);    %odfiltrujeme prvu obrovsku hodnotu, ktora sposobi nepresnosti v NARX
        POut =          [POut, P_out];
        Q_out(1) = Q_out(2);    %odfiltrujeme prvu obrovsku hodnotu, ktora sposobi nepresnosti v NARX
        QOut =          [QOut, Q_out];
        T =             [T,     t];
    end
    oneDayData = length(battery_in);
    clear V2G to tout logsout wind_in variableLoad_in t solar_in simulation...
        Q_out P_out charger_in battery_in plotData i
    save('v1simData.mat');
else
    load('v1simData.mat');
end
if exist('plotData','var') == 0
plotData = 1;
end
if plotData
    fullBatt = pickDay(batteryIn,1:7);
    fullCharger = pickDay(chargerIn,1:7);
    fullSolar = pickDay(solarIn,1:7);
    fullVarload = pickDay(variableLoadIn,1:7);
    fullWind = pickDay(windIn,1:7);
    fullPout = pickDay(POut,1:7);
    fullQout = pickDay(QOut,1:7);
    T = [0:60:(7*60*60*24)+60*6]';
    
figure(1)
plot(T,fullPout);
hold on
plot(T,fullQout);
title('Vystupy')
xlabel('Cas')
legend('P','Q');

figure(2)
hold on
title('Vstupy')

subplot(5,1,1)
plot(T,fullBatt);
xlabel('Cas')
ylabel('Bateria [W]')

subplot(5,1,2)
plot(T,fullCharger);
xlabel('Cas')
ylabel('Nabijacka [W]')

subplot(5,1,3)
plot(T,fullSolar);
xlabel('Cas')
ylabel('Slnko [W]')

subplot(5,1,4)
plot(T,fullVarload);
xlabel('Cas')
ylabel('Variable load [W]')

subplot(5,1,5)
plot(T,fullWind);
xlabel('Cas')
ylabel('Vietor [W]')
end