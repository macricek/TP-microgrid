%% Simulacia
close all
%clear
clc

Ts = 1; %Vzorkovacia perioda
sampleTimeWind = 20; %Perioda zmeny rychlosti vetra
sampleTimeLoad = 10; %Perioda zmeny zataze siete


simulation = 0; %ak je 0 tak ocakavame nacitanie z .mat subora
showGraphs = 0;

if simulation > 0
simOut = sim('simpleMicrogrid_v3_0.slx')

P = simOut.P_out;
Q = simOut.Q_out;
T = simOut.T;

carChargerControl = simOut.carChargerControl;  %Stav nabijacej stanice (nabijam auta/beriem od nich)
carBatteryVoltage = simOut.carBatteryVoltage;  
carBatteryCurrent = simOut.carBatteryCurrent;  
carBatteryPercentage = simOut.carBatteryPercentage;  %Percentualne vyjadrenie ako su auta nabite

% Napatie jednotlivych faz na nabijacej stanici
voltageCarChargerA = simOut.voltageCarChargerA;
voltageCarChargerB = simOut.voltageCarChargerB;
voltageCarChargerC = simOut.voltageCarChargerC;

% Napatie jednotlivych faz v gride
voltageGridA = simOut.voltageGridA;
voltageGridB = simOut.voltageGridB;
voltageGridC = simOut.voltageGridC;

varLoad = simOut.variableLoad_in;  %Variabilna zataz
windIn = simOut.wind_in;  %Rychlost vetra posobiaca na veternu turbinu

clear simulation simOut;
save('matlab.mat')
else
    load('data.mat')
end

if showGraphs>0

Ts
sampleTimeWind
sampleTimeLoad

figure(3)
ax1=subplot(3,1,1)
plot(T,carChargerControl);
title('Ovladanie nabijacej stanice')
xlabel('Cas')
ylabel('stav')

ax3=subplot(3,1,2);
plot(T,varLoad);
title('Variabilna zataz')
ylabel('W')

ax4=subplot(3,1,3);
plot(T,windIn);
title('Rychlost vetra')
ylabel('v[m/s]')
xlabel('Vzorky')

linkaxes([ax1,ax3,ax4],'x')


%Vykreslenie faz

figure(1)
ax5=subplot(2,1,1);
plot(T,voltageGridA);
hold on;
plot(T,voltageGridB);
plot(T,voltageGridC);
title('Fazy grid');
ylabel('Napatie[V]')
legend('A','B','C');

ax6=subplot(2,1,2);
plot(T,voltageCarChargerA);
hold on;
plot(T,voltageCarChargerB);
plot(T,voltageCarChargerC);
title('Fazy nabijacia stanica');
legend('A','B','C');
xlabel('Vzorky')
ylabel('Napatie[V]')

linkaxes([ax5,ax6],'x')


%Udaje o bateriach v autach zapojenych do nabijacej stanice
figure(2)
ax7=subplot(4,1,1);
plot(T,carBatteryPercentage);
title('Uroven baterie')
ylabel('%')

ax8=subplot(4,1,2);
plot(T,carBatteryVoltage);
title('Napatie baterie')
ylabel('V')

ax9=subplot(4,1,3);
plot(T,carBatteryCurrent);
title('Prud baterie')
ylabel('A')

ax10=subplot(4,1,4);
plot(T,carChargerControl);
title('Ovladanie nabijacej stanice')
xlabel('Vzorky')
ylabel('stav')

linkaxes([ax7,ax8,ax9,ax10],'x')

figure(44)
plot(T,voltageGridA);
title('Faza grid');
ylabel('Napatie[V]')
xlabel('Vzorky')
legend('A');

end

%volba vstupu a vystupu
arrU = [windIn,varLoad,carChargerControl];
yV = voltageGridA;
%transformacia vstupu a vystupu

u = transToCell(arrU');
y = transToCell(yV');

len = round(length(u));
lendiv2 = round(len/2);
% trenovacie data
utrain=u(1:lendiv2);
ytrain=y(1:lendiv2);

% testovacie data
utest=u(lendiv2+1:length(u));
ytest=y(lendiv2+1:length(y));
