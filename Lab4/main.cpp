#include <iostream>
#include <vector>
#include <cmath>
#include <algorithm>

int xor_count(const std::vector<int>& arr1, const std::vector<int>& arr2) {
    int count = 0;
    for (size_t i = 0; i < arr1.size(); ++i) {
        count += arr1[i] ^ arr2[i];
    }
    return count;
}

int multiplyAndSum(const std::vector<int>& arr1, const std::vector<int>& arr2) {
    int result = 0;
    for (size_t i = 0; i < arr1.size(); ++i) {
        result += arr1[i] * arr2[i];
    }
    return result;
}

double normalMultiplyAndSum(const std::vector<int>& arr1, const std::vector<int>& arr2) {
    return static_cast<double>(multiplyAndSum(arr1, arr2)) / (sqrt(multiplyAndSum(arr1, arr1)) * sqrt(multiplyAndSum(arr2, arr2)));
}

int main() {
    std::vector<int> lfsr1 = {0, 1, 0, 1, 0};
    std::vector<int> lfsr2 = {1, 0, 0, 0, 1};
    int numBits = 10;
    std::vector<int> goldCode(numBits, 0);

    for (int i = 0; i < numBits; ++i) {
        int xorResult = lfsr1[4] ^ lfsr2[4];
        int newbit1 = lfsr1[0] ^ lfsr1[2];
        int newbit2 = lfsr2[1] ^ lfsr2[3];

        for (int j = 4; j > 0; --j) {
            lfsr1[j] = lfsr1[j - 1];
            lfsr2[j] = lfsr2[j - 1];
        }

        lfsr1[0] = newbit1;
        lfsr2[0] = newbit2;

        goldCode[i] = xorResult;
    }

    std::cout << "Сгенерированная последовательность Голда:" << std::endl;
    for (int bit : goldCode) {
        std::cout << bit << " ";
    }
    std::cout << std::endl;
    std::cout << "Сдвиг | 1 бит | 2 бит |  3 бит |  4 бит |  5 бит |  6 бит |  7 бит |  8 бит |  9 бит |  10 бит | Автокорреляция" << std::endl;
    for (int i = 0; i < numBits; i++) {
        std::vector<int> newGoldCode(goldCode.size());
        if (i == 0) {
            newGoldCode = goldCode;
            double autocorr = static_cast<double>(numBits - 2 * xor_count(goldCode, newGoldCode))/numBits;
            std::cout << "  " << i << "   |  " << newGoldCode[0] << "    |  " << newGoldCode[1] << "    |  " 
            << newGoldCode[2] << "     |  " << newGoldCode[3] << "     |  " 
            << newGoldCode[4] << "     |  " << newGoldCode[5] << "     |  " << newGoldCode[6]
            << "     |  "<< newGoldCode[7] << "     |  " << newGoldCode[8] << "     |   " << newGoldCode[9] 
            << "     |  " << autocorr << std::endl;
        } else {
            std::rotate_copy(goldCode.rbegin(), goldCode.rbegin() + i-1, goldCode.rend(), newGoldCode.begin());
            double autocorr = static_cast<double>(numBits - 2 * xor_count(goldCode, newGoldCode))/numBits;
            std::cout << "  " << i << "   |  " << newGoldCode[0] << "    |  " << newGoldCode[1] << "    |  " 
            << newGoldCode[2] << "     |  " << newGoldCode[3] << "     |  " 
            << newGoldCode[4] << "     |  " << newGoldCode[5] << "     |  " << newGoldCode[6]
            << "     |  "<< newGoldCode[7] << "     |  " << newGoldCode[8] << "     |   " << newGoldCode[9] 
            << "     |  " << autocorr << std::endl;
        }
    }

    std::vector<int> lfsr3 = {0, 1, 0, 1, 1};
    std::vector<int> lfsr4 = {0, 1, 1, 0, 0};
    std::vector<int> goldCode2(numBits, 0);

    for (int i = 0; i < numBits; ++i) {
        int xorResult2 = lfsr3[4] ^ lfsr4[4];
        int newbit3 = lfsr3[0] ^ lfsr3[2];
        int newbit4 = lfsr4[1] ^ lfsr4[3];

        for (int j = 4; j > 0; --j) {
            lfsr3[j] = lfsr3[j - 1];
            lfsr4[j] = lfsr4[j - 1];
        }

        lfsr3[0] = newbit3;
        lfsr4[0] = newbit4;

        goldCode2[i] = xorResult2;
    }

    std::cout << "Другая сгенерированная последовательность Голда:" << std::endl;
    for (int bit : goldCode2) {
        std::cout << bit << " ";
    }
    std::cout << std::endl;

    double newcorr = normalMultiplyAndSum(goldCode, goldCode2);

    std::cout << "Значение взаимной корреляции исходной и новой последовательности Голда: " << newcorr << std::endl;

    return 0;
}
