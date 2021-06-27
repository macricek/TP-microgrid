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
carChargerControl = [zeros(2000,1);ones(2000,1);zeros(1000,1)];
carBatteryVoltage = cbv + newrand(100,5000,1)';
carBatteryCurrent = cbc;
carBatteryPercentage = cbp;

% Napatie jednotlivych faz na nabijacej stanici
voltageCarChargerA = vcca;
voltageCarChargerB = vccb;
voltageCarChargerC = vccc;

% Napatie jednotlivych faz v gride

voltageGridA = vga + newrand(100,5000)';
voltageGridB = vgb ;
voltageGridC = vgc + newrand(100,5000)';

for i=1:5000
if voltageGridA(i) > 270 || voltageGridA(i) < 250
    voltageGridA(i) = 265;
end
if voltageGridB(i) > -520 || voltageGridB(i) < -570
   voltageGridB(i) = -535;
end
if voltageGridC(i) > 270 || voltageGridC(i) < 250
    voltageGridC(i) = 265;
end
end

varLoad = vl + newrand(10,5000,70000)';
windIn = abs(wi + newrand(20,5000,1)');

P = Pp;
Q = Qq;
T = Tt;


save('data','carChargerControl','carBatteryVoltage','carBatteryCurrent',...
    'carBatteryPercentage','voltageCarChargerA','voltageCarChargerB',...
    'voltageCarChargerC','voltageGridA','voltageGridB','voltageGridC',...
    'varLoad','windIn','P','Q','T');

function novyrand = newrand(every,numofdata,sizeOF)
if nargin < 3
    sizeOF = 10;
end
coef = numofdata/every;
randomik = ((rand(coef,1) - 0.5) * sizeOF);
cnt = 1;
for i= 1:coef
    for j=1:every
    novyrand(cnt) = randomik(i);
    cnt = cnt + 1;
    end
end
end