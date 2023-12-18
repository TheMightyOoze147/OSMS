#include <iostream>
#include <vector>
#include <cstdlib>
#include <algorithm>

const int BigN = 250;
const int N = 20 + 10; 

std::vector<int> CRC(std::vector<int>& data) {
    std::vector<int> polinome{1, 1, 0, 1, 1, 1, 1, 0}; //Десятый вариант, G = x^7 + x^6 + x^4 + x^3 + x^2 + x
    std::vector<int> temporary_div;
    std::vector<int> zero_polinome(polinome.size(), 0);
    
    //Дополнение массива данных нулями
    for (int i = 0; i < polinome.size() - 1; i++) {
        data.push_back(0);
    }
    
    //Копирование данных в новый массив для произведения операции деления
    std::copy_if(data.begin(), data.begin() + polinome.size(), std::back_inserter(temporary_div), [](int i){ return true; });
    int end_temp = polinome.size();
    
    //xor первых polinome.size() битов и запись в конец temporary_div
    for (int i = 0; i < end_temp; i++) {
        temporary_div.push_back(temporary_div[i] ^ polinome[i]);
    }
    
    //Удаление первых использованных битов
    temporary_div.erase(temporary_div.begin(), temporary_div.begin() + polinome.size() + 1);
    temporary_div.push_back(data[polinome.size() + 1]);
    int count = 0;
    
    for (int j = polinome.size(); (j < data.size()) && (count < data.size() - polinome.size() + 1); j++, count++) {
        if (temporary_div[0] == 1) {
            for (int i = 0; i < end_temp; i++) {
                temporary_div.push_back(temporary_div[i] ^ polinome[i]);
            }
            temporary_div.erase(temporary_div.begin(), temporary_div.begin() + polinome.size() + 1);
            if (j + 1 != data.size()) {temporary_div.push_back(data[j+1]);}
        } 
        else {
            for (int i = 0; i < end_temp; i++) {
                temporary_div.push_back(temporary_div[i] ^ zero_polinome[i]);
            }
            temporary_div.erase(temporary_div.begin(), temporary_div.begin() + polinome.size() + 1);
            if (j + 1 != data.size()) {temporary_div.push_back(data[j+1]);}
        }
    }
    
    return temporary_div;
}

int main() {
    std::vector<int> data_tx(N), big_data_tx(BigN);
    
    std::cout << "\nИсходная битовая последовательность: " << std::endl;
    for (auto &d : data_tx) {
        d = rand() % 2;
        std::cout << d << " ";
    }
    
    std::vector<int> data_rx(data_tx);
    std::vector<int> CRC_tx = CRC(data_tx);
    
    std::cout << std::endl << "\nCRC для передаваемого пакета: ";
    for (auto &i : CRC_tx) {
        std::cout << i << " ";
        data_rx.push_back(i);
    }
    std::vector<int> CRC_rx = CRC(data_rx);
    int CRC_rx_summ = 0;
    
    std::cout << std::endl << "\nCRC для получаемого пакета: ";
        for (auto &i : CRC_rx) {
        std::cout << i << " ";
        CRC_rx_summ+=i;
    }
    
    auto error_msg = [](int cntr) {
        if (cntr != 0) {
        std::cout << std::endl << "\nПакет принят с ошибкой!";
        }
        else std::cout << std::endl << "\nОшибок в пакете нет!";
    };
    
    error_msg(CRC_rx_summ);
    
    std::cout << std::endl << "\nИсходная битовая последовательность для N = 250: " << std::endl;
    for (auto &d : big_data_tx) {
        d = rand() % 2;
        std::cout << d << " ";
    }
    
    std::vector<int> big_data_rx(big_data_tx);
    std::vector<int> big_CRC_tx = CRC(big_data_tx);
    
    std::cout << std::endl << "\nCRC для передаваемого пакета N = 250: ";
    for (auto &i : big_CRC_tx) {
        std::cout << i << " ";
        big_data_rx.push_back(i);
    }
    std::vector<int> big_CRC_rx = CRC(big_data_rx);
    int big_CRC_rx_summ = 0;
    
    std::cout << std::endl << "\nCRC для получаемого пакета N = 250: ";
        for (auto &i : big_CRC_rx) {
        std::cout << i << " ";
        big_CRC_rx_summ+=i;
    }
    
    error_msg(big_CRC_rx_summ);
    
    std::cout << std::endl << "\nДля цикла 250+CRC length итераций: ";
    int errors_detected = 0, errors_not_detected = 0;
    
    for (int i = 0; i < big_data_rx.size(); i++) {
        int flag = 0;
        std::vector<int> copy_big_data_rx;
        std::copy_if(big_data_rx.begin(), big_data_rx.end(), std::back_inserter(copy_big_data_rx), [](int i){ return true; });
        copy_big_data_rx[i] = -1;
        std::vector<int> copy_big_CRC_rx = CRC(copy_big_data_rx);
        for (auto &j : copy_big_CRC_rx) {
            if (j != 0) {
                flag++;
            }
        }
        if (flag != 0) errors_detected++;
        else errors_not_detected++;
    }
    std::cout << std::endl << "\nОшибок обнаружено: " << errors_detected << std::endl << "\nОшибок не обнаружено: " << errors_not_detected;
}