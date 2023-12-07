t = 0:0.01:1;
s1 = cos(2 * pi * 10 * t);
s2 = cos(2 * pi * 14 * t);
s3 = cos(2 * pi * 21 * t);

a = 5 * s1 + 4 * s2 + s3;
b = 3 * s1 + s3;

ma = [0.3, 0.2, -0.1, 4.2, -2, 1.5, 0];
mb = [0.3, 4, -2.2, 1.6, 0.1, 0.1, 0.2];

% Анонимная функция для поиска корелляции
multiplyAndSum = @(arr1, arr2) sum(arr1 .* arr2);

% Анонимная функция для поиска нормализованной корелляции
normalMultiplyAndSum = @(arr1, arr2) multiplyAndSum(arr1, arr2)/sqrt(sum(arr1 .^ 2) * sum(arr2 .^ 2));

% Лямбда функция для поэлементного сдвига последовательности
shiftArray = @(arr, shift) circshift(arr, [0, -shift]);

s1a = multiplyAndSum(s1, a);
s1b = multiplyAndSum(s1, b);
s1an = normalMultiplyAndSum(s1, a);
s1bn = normalMultiplyAndSum(s1, b);

disp("Значение корреляции s1 с a " + s1a + ", с b " + s1b);
disp("Значение взаимной корреляции s1 с a " + s1an + ", с b " + s1bn);

mamb_corr = normalMultiplyAndSum(ma, mb);
disp("Значение взаимной корелляции для a и b " + mamb_corr);

% Нахождение максимальной корелляции для массивов ma и mb
maxmamb = 0;
maxmamb_index = 0;
corr_valuesmamb = [];
for n = 1:1:size(mb, 2)
    newmb_corr = normalMultiplyAndSum(ma, shiftArray(mb, n));
    corr_valuesmamb = [corr_valuesmamb, newmb_corr];
    if maxmamb < newmb_corr
        maxmamb = newmb_corr;
        maxmamb_index = n;
    end
end

disp("Максимальная корреляция для a и b " + maxmamb);

figure(1);
subplot(3, 1, 1);
plot(0:numel(ma)-1, ma, 0:numel(mb)-1, mb);
title("Два массива значений a b");
subplot(3, 1, 2);
plot(0:numel(corr_valuesmamb)-1, corr_valuesmamb);
title("Зависимость взаимной корреляции последовательностей от величины циклического сдвига");
subplot(3, 1, 3);
plot(0:numel(ma)-1, ma, 0:numel(mb)-1, shiftArray(mb, maxmamb_index));
title("b сдвинута на величину, где зафиксирована максимальная корреляция");