%% Simulacia
close all
clear
clc

Ts = 1;
simulation = 0;
if simulation > 0
sim('simpleMicrogrid_v0.slx')
figure(1)
plot(T,batteryPref);
hold on
plot(T,varLoad);
title('Vstupy')
xlabel('Cas')
legend('battery','variableload');

figure(2)
hold on
title('Vstupy')

subplot(5,1,1)
plot(T,f);
xlabel('Cas')
ylabel('Frekvencia [Hz]')

subplot(5,1,2)
plot(T,P);
xlabel('Cas')
ylabel('Vykon [W]')

subplot(5,1,3)
plot(T,Q);
xlabel('Cas')
ylabel('Aktivny [W]')

subplot(5,1,4)
plot(T,U);
xlabel('Cas')
ylabel('Napatie [V]')

subplot(5,1,5)
plot(T,percBatt);
xlabel('Cas')
ylabel('% baterie')
else
    load('matlab.mat')
end

% arrU = [batteryPref,varLoad];
% u = transToCell(arrU');
% %yV = [P,Q,U(:,1),f]';
% yV = U;
% y = transToCell(yV');

