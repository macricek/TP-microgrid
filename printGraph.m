%% function that print graph from training session
%% option - 1 -> training , 2 -> testing ,  3 -> closed loop
function printGraph(Tc, Yc, option, path, ylabelstring)
YTC_mat = cell2mat(Yc)';
TrC_mat = cell2mat(Tc)';

if option == 3
titleString = "Testovacie Close Loop data";
saveString = "\closed";
colorka = 'g';
elseif option == 2
titleString = "Testovacie data";
saveString = "\test";
colorka = 'r';
else
titleString = "Trenovacie data";
saveString = "\train";   
colorka = 'k';
end

[~,b] = size(YTC_mat);
for i = 1:b
a = figure;
hold on
plot(TrC_mat(:,i),colorka)
plot(YTC_mat(:,i))
title(titleString);
xlabel('vzorky');
ylabel(ylabelstring(i));
legend('NARX','Data');
saveas(a, strcat(path,saveString,ylabelstring(i),".bmp"));
hold off
end
end