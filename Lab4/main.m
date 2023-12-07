lfsr1 = [0, 1, 0, 1, 0]; %10
lfsr2 = [1, 0, 0, 0, 1]; %17
numBits = 10;
tableData = zeros(10, 12);
xor_count = @(arr1, arr2) sum(xor(arr1, arr2));
multiplyAndSum = @(arr1, arr2) sum(arr1 .* arr2);
normalMultiplyAndSum = @(arr1, arr2) multiplyAndSum(arr1, arr2)/sqrt(sum(arr1 .^ 2) * sum(arr2 .^ 2));


goldCode = generateGoldCode(numBits, lfsr1, lfsr2);

lfk = autocorr(goldCode);
disp('Сгенерированная последовательность Голда:');
disp(goldCode);

for i = 0:numBits-1
    tableData(i+1, 1) = i;
    newGoldCode = circshift(goldCode, [0 i]);
    for n = 1:numBits
        tableData(i+1, n+1) = newGoldCode(n);
        tableData(i+1, 12) = lfk(i+1);
    end
end

variableNames = {'Shift', 'Bit1', 'Bit2', 'Bit3', 'Bit4', 'Bit5', 'Bit6', 'Bit7', 'Bit8', 'Bit9', 'Bit10', 'Autocorrelation'};
T = array2table(tableData, 'VariableNames', variableNames);

lfsr3 = [0, 1, 0, 1, 1];
lfsr4 = [0, 1, 1, 0, 0];

goldCode2 = generateGoldCode(numBits, lfsr3, lfsr4);
lfk2 = autocorr(goldCode2);

disp('Другая сгенерированная последовательность Голда:');
disp(goldCode2);

newcorr = normalMultiplyAndSum(goldCode, goldCode2);
disp('Значение взаимной корреляции исходной и новой последовательности Голда:');
disp(newcorr);

figure(1);
plot(0:numel(lfk)-1, lfk, 0:numel(lfk2)-1, lfk2);
xlabel("Лаг");
ylabel("Значение автокорреляции");
title("функция автокорреляции в зависимости от величины задержки");
grid();
legend("Автокорреляция последовательности 1", "Автокорреляция последовательности 2");
