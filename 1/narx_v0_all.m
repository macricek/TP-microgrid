clc
clear
close all
%       [1,1,3,1];
%yV_v = [P,Q,U,f];

Ts = 1;
%% get data from simulation
v0_getData
arrU = [batteryPref,varLoad];
grad = 1e-7;
%% prepare dataset for NARX U
n=4;   % pocet minulych hondnot y
m=4;   % pocet minulych hondnot u
hn=5; % pocet skrytych neuronov

u = transToCell(arrU');
yV = U(:,1);
y = transToCell(yV');
goal = 1e-7;
narx_v0

%% dataset for NARX f
n=2;   % pocet minulych hondnot y
m=4;   % pocet minulych hondnot u
hn=10; % pocet skrytych neuronov
u = transToCell(arrU');
yV = f;
y = transToCell(yV');
goal = 1e-18;
grad = 1e-15;
narx_v0

%% P
n=1;   % pocet minulych hondnot y
m=4;   % pocet minulych hondnot u
hn=10; % pocet skrytych neuronov
u = transToCell(arrU');
yV = P;
y = transToCell(yV');
goal = 1e-3;
narx_v0

%% Q
n=4;   % pocet minulych hondnot y
m=4;   % pocet minulych hondnot u
hn=5; % pocet skrytych neuronov
u = transToCell(arrU');
yV = Q;
y = transToCell(yV');
goal = 1e-5;
narx_v0