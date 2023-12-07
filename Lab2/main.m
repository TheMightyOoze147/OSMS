TXpowerBS = 46; %[dBm]
TXpowerUE = 24; %[dBm]
AntGainBS = 21; %[dBi]
MIMOGain = 3;
FeederLoss = 2;
IM = 1; %[dB]
PenetrationM = 15;
f_Hz = 1.8e9; %[Hz]
f_MHz = 1800; %[MHz]
f_GHz = 1.8; %[GHz]
f_UL = 10e6; 
f_DL = 20e6; 
c = 3e8; %[m/s]
d = 0:1:9999; %[m]
A = 46.3;
B = 33.9;
hBS = 150; %[m]
hms = 10; %[m]
S = 100;
S_femto = 4;

%Рассчёт модели COST231
a = 3.2 * power(log10(11.75 * hms), 2) - 4.97;
Lclutter = 3;
%s = 1;
s = 47.88 + 13.9 * log10(f_MHz) - (13.9 * log10(hBS)/log10(50));

for x = 1:1:length(d)-1
    if x < 1000
        s (end + 1) = (47.88 + 13.9 * log10(f_MHz) - 13.9 * log10(hBS))/log10(50); %Для d < 1km
    else 
        s (end + 1) = 44.9 - 6.55 * log10(f_MHz); %Для d >= 1km
    end
end


COST231_PL = A + B * log10(f_MHz) - 13.82 * log10(hBS) - a + s .* log10(d/1000) + Lclutter;

%Рассчёт модели FSPM
FSPM_PL = 20 * log10((4 * pi * f_Hz * d)/c);

%Рассчёт модели UMiNLOS
UMiNLOS_PL = 26 * log10(f_GHz) + 22.7 + 36.7 * log10(d);

%Рассчёт Walfish-Ikegami LLOS и Walfish-Ikegami LNLOS
delta_h = 250;

L1_1 = 0;
b = 15; %Среднее расстояние между зданиями
w = 20; %Средняя ширина улиц

ka = 54 - 0.8 * ((hBS/1000) - delta_h) * 1/0.5;
for g = 1/1000:1/1000:(length(d)-1)/1000
    if g <= 0.5
        ka(end + 1) = 54 - 0.8 * (hBS/1000 - delta_h/1000) * g/0.5; %hBS <= delta_h and d <= 0.5
    else
        ka(end + 1) = 54 - 0.8 * (hBS/1000 - delta_h/1000);
    end
end

fi = 45;
kd = 19 - 15 * (hBS/1000 - delta_h)/delta_h; %hBS <= delta_h

kf = -4 + 0.7 * ((f_MHz/925)-1);
LLOS = 42.6 + 20 * log10(f_MHz) + 26 * log10(d);
L0 = 32.44 + 20 * log10(f_MHz) + 20 * log10(d/1000);
L1 = L1_1 + ka + kd * log10(d) + kf * log10(f_MHz) - 9 * log10(b);
L2 = -16.9 - 10 * log10(w) + 10 * log10(f_MHz) + 20 * log10(delta_h/1000 - hms/1000) - 10 + 0.354 * fi;

L3 = L1 + L2;

if L1 + L2 > 0
    LNLOS = L0 + L1 + L2;
else
    LNLOS = L0;
end

figure(1);
subplot(2, 1, 1);
plot(d, FSPM_PL);
title('FSPM');
grid();
subplot(2, 1, 2);
plot(d, UMiNLOS_PL, d, COST231_PL, d, LLOS, d, LNLOS);
title('Модели распространения сигнала');
%plot(d, FSPM_PL, d, LLOS);
%legend('FSPM', 'LLOS');
%plot(d, FSPM_PL, d, LNLOS);
%legend('FSPM', 'LNLOS');
grid();
ylabel('Потери PL [dBm]')
xlabel('Расстояние [m]')
legend('UMiNLOS', 'COST231', 'Walfish-Ikegami LLOS', 'Walfish-Ikegami LNLOS');

ThermalNoiseBS = -174 + 10 * log10(f_DL);
RxSensBS = 2.4 + ThermalNoiseBS + 4;
ThermalNoiseUE = -174 + 10 * log10(f_UL);
RxSensUE = 6 + ThermalNoiseUE + 2;

DL_MAPL = (TXpowerBS - FeederLoss + AntGainBS + MIMOGain - IM - PenetrationM - RxSensUE).*ones(1, length(d)); %[dB]
UL_MAPL = (TXpowerUE - FeederLoss + AntGainBS + MIMOGain - PenetrationM - IM - RxSensBS).*ones(1, length(d)); %[dB]

figure(2);
plot(d, UMiNLOS_PL, 'm', d, COST231_PL, 'r', d, DL_MAPL, 'g', d, UL_MAPL, '--b');
legend('UMiNLOS', 'COST231', 'MAPLDL', 'MAPLUL');
grid();
ylabel('Потери PL [dBm]');
xlabel('Дистанция [m]')

%Рассчёт радиуса покрытия базовой станции по модели COST231 для макро-сот
BS_Radius_COST = 0;
for z = 1:10:length(COST231_PL)
    if UL_MAPL(z) > COST231_PL(z)
        BS_Radius_COST = z;
    end
end

%Рассчёт радиуса покрытия базовой станции по модели UMiNLOS для фемто-сот
BS_Radius_UMiNLOS = 0;
for z = 1:10:length(UMiNLOS_PL)
    if UL_MAPL(z) > UMiNLOS_PL(z)
        BS_Radius_UMiNLOS = z;
    end
end

BS_S = 1.95 * power(BS_Radius_COST/1000, 2); %Рассчёт площади покрытия макро-сот
BS_S_femto = 1.95 * power(BS_Radius_UMiNLOS/1000, 2); %Рассчёт площади покрытия фемто-сот
result_macro = S/BS_S; %Количество макро-сот для покрытия площади 100кв км
result_femto = S_femto/BS_S_femto; %Количество фемто-сот для покрытия площади 4кв км

%Таблица
BS_column = {'Macro BS'; 'Femto BS'};
Original_S_km2 = [S; S_femto];
Radius_m = [BS_Radius_COST; BS_Radius_UMiNLOS];
BS_square_km = [BS_S; BS_S_femto];
Number_of_BS_rounded = [round(result_macro); round(result_femto)];
T = table(Original_S_km2, Radius_m, BS_square_km, Number_of_BS_rounded, 'RowNames',BS_column);