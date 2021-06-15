clc
close all
clear

path = 'matlab';
%load(path);
path1 = path;
cbc = [];
cbp = [];
cbv = [];
ccc = [];
Pp = [];
Qq = [];
Tt = [];
vcca = [];
vccb = [];
vccc = [];
vga = [];
vgb = [];
vgc = [];
vl = [];
wi = [];

for i=0:4
load(path1);
cbc = [cbc;carBatteryCurrent];
cbp = [cbp;carBatteryPercentage];
cbv = [cbv;carBatteryVoltage];
ccc = [ccc;carChargerControl];
Pp = [Pp;P];
Qq = [Qq;Q];
Tt = [Tt;T+100*i];
vcca = [vcca;voltageCarChargerA];
vccb = [vccb;voltageCarChargerB];
vccc = [vccc;voltageCarChargerC];
vga = [vga;voltageGridA];
vgb = [vgb;voltageGridB];
vgc = [vgc;voltageGridC];
vl = [vl;varLoad];
wi = [wi;windIn];
path1 = strcat(path,string(i+1));
end

%% final prepis
carChargerControl = ccc;
carBatteryVoltage = cbv;
carBatteryCurrent = cbc;
carBatteryPercentage = cbp;

% Napatie jednotlivych faz na nabijacej stanici
voltageCarChargerA = vcca;
voltageCarChargerB = vccb;
voltageCarChargerC = vccc;

% Napatie jednotlivych faz v gride

voltageGridA = vga + newrand(20,5000)';
voltageGridB = vgb + newrand(20,5000)';
voltageGridC = vgc + newrand(20,5000)';

for i=1:5000
if voltageGridA(i) > 270 || voltageGridA(i) < 250
    voltageGridA(i) = 265;
end
if voltageGridB(i) > 270 || voltageGridB(i) < 250
    voltageGridB(i) = 265;
end
if voltageGridC(i) > 270 || voltageGridC(i) < 250
    voltageGridC(i) = 265;
end
end

varLoad = vl;
windIn = wi;

P = Pp;
Q = Qq;
T = Tt;

save('data','carChargerControl','carBatteryVoltage','carBatteryCurrent',...
    'carBatteryPercentage','voltageCarChargerA','voltageCarChargerB',...
    'voltageCarChargerC','voltageGridA','voltageGridB','voltageGridC',...
    'varLoad','windIn','P','Q','T');

function novyrand = newrand(every,numofdata)
coef = numofdata/every;
randomik = ((rand(coef,1) - 0.5) * 10);
cnt = 1;
for i= 1:coef
    for j=1:every
    novyrand(cnt) = randomik(i);
    cnt = cnt + 1;
    end
end
end