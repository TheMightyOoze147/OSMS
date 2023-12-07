function goldCode = generateGoldCode(numBits, arr1, arr2)
    % Инициализация LFSR
    lfsr1 = arr1;
    lfsr2 = arr2;
    
    % Предварительное выделение места для goldCode
    goldCode = zeros(1, numBits);
    
    % Генерация Gold Code
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
end