lfsr1 = [0, 1, 0, 1, 0]; %10
lfsr2 = [1, 0, 0, 0, 1]; %17
numBits = 10;
goldCode = zeros(1, numBits);
tableData = zeros(10, 12);
xor_count = @(arr1, arr2) sum(xor(arr1, arr2));
multiplyAndSum = @(arr1, arr2) sum(arr1 .* arr2);
normalMultiplyAndSum = @(arr1, arr2) multiplyAndSum(arr1, arr2)/sqrt(sum(arr1 .^ 2) * sum(arr2 .^ 2));

for i = 1:numBits
    xorResult = xor(lfsr1(5), lfsr2(5));
    newbit1 = xor(lfsr1(1), lfsr1(3));
    newbit2 = xor(lfsr2(2), lfsr2(4));
    lfsr1 = circshift(lfsr1, [0 1]);
    lfsr2 = circshift(lfsr2, [0 1]);
    lfsr1(1) = newbit1;
    lfsr2(1) = newbit2;
    goldCode(i) = xorResult;
end

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
goldCode2 = zeros(1, numBits);


for i = 1:numBits
    xorResult2 = xor(lfsr3(5), lfsr4(5));
    newbit3 = xor(lfsr3(1), lfsr3(3));
    newbit4 = xor(lfsr4(2), lfsr4(4));
    lfsr3 = circshift(lfsr3, [0 1]);
    lfsr4 = circshift(lfsr4, [0 1]);
    lfsr3(1) = newbit3;
    lfsr4(1) = newbit4;
    goldCode2(i) = xorResult2;
end
lfk2 = autocorr(goldCode2);

disp('Другая сгенерированная последовательность Голда:');
disp(goldCode2);

newcorr = normalMultiplyAndSum(goldCode, goldCode2);
disp('Значение взаимной корреляции исходной и новой последовательности Голда:');
disp(newcorr);

figure(1);
plot(0:numel(lfk2)-1, lfk2);
xlabel("Лаг");
ylabel("Значение автокорреляции");
title("функция автокорреляции в зависимости от величины задержки");
