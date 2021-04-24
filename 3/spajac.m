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
voltageGridA = vga;
voltageGridB = vgb;
voltageGridC = vgc;

varLoad = vl;
windIn = wi;

P = Pp;
Q = Qq;
T = Tt;

save('data','carChargerControl','carBatteryVoltage','carBatteryCurrent',...
    'carBatteryPercentage','voltageCarChargerA','voltageCarChargerB',...
    'voltageCarChargerC','voltageGridA','voltageGridB','voltageGridC',...
    'varLoad','windIn','P','Q','T');