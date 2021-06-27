%% Simulacia
%close all
%clear
%clc

Ts = 0.01;
simulation = 0;
figures = 1;
if simulation > 0
sim('simpleMicrogrid_v0kr.slx')
save('matlab1.mat');
else
    load('matlab1.mat')
end   
if figures > 0
figure(1)
subplot(2,1,1)
plot(T,batteryPref);
hold on
plot(T,varLoad);
title('Vstupy')
xlabel('Cas')
ylabel('Vykon [W]');
legend('battery','variableload');
subplot(2,1,2)
plot(T,f);
xlabel('Cas')
ylabel('Frekvencia [Hz]');
title('Vystupy');

figure(2)
hold on
title('Vystupy')

subplot(3,1,1)
plot(T,P);
xlabel('Cas')
ylabel('Vykon [W]')

subplot(3,1,2)
plot(T,U);
xlabel('Cas')
ylabel('Napatie [V]')

subplot(3,1,3)
plot(T,percBatt);
xlabel('Cas')
ylabel('% baterie')
end

arrU = [batteryPref,varLoad];
u = transToCell(arrU');
yV = f;
y = transToCell(yV');

