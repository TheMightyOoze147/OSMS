#include <iostream>
#include <cmath>
#include <iomanip>

//Функция для нахождения корелляции меж двух массивов
int correlate(int first[], int second[], int size){
    int correlation = 0;
    for (int i = 0; i < size; i++) {
        correlation += first[i] * second[i];
    }
    return correlation;
}

//Функция для нахождения нормализованной корелляции меж двух массивов
double normal_correlate(int first[], int second[], int size) {
    double normal_correlation = 0, first_squared = 0, second_squared = 0;
    for (int i = 0; i < size; i++) {
        first_squared += pow(first[i], 2);
        second_squared += pow(second[i], 2);
    }
    normal_correlation = correlate(first, second, size)/pow((first_squared * second_squared), 0.5);
    return normal_correlation;
}

int main()
{   
    int a[] = {6, 2, 3, -2, -4, -4, 1, 1};
    int b[] = {3, 1, 5, 0, -3, -4, 2, 3};
    int c[] = {-1, -1, 3, -9, 2, -8, 4, -4};
    
    //Лямбда-функция для вычисления размера массива
    auto arraySize = [](auto& arr) {
        return sizeof(arr) / sizeof(arr[0]);
    };
    
    std::cout << "Корелляция между массивами a, b, и c:" << std::endl
    << "\\ | a | b | c |" << std::endl
    << "a | - | " << correlate(a, b, arraySize(a)) << "|" << correlate(a, c, arraySize(c)) << " |" << std::endl
    << "b | " << correlate(b, a, arraySize(b)) << "| - |" << correlate(b, c, arraySize(c)) << " |" << std::endl
    << "c | " << correlate(c, a, arraySize(c)) << "| " << correlate(c, b, arraySize(c)) << "| - |" << std::endl;
    
        std::cout << "Нормализованная корелляция между массивами a, b, и c:" << std::endl
    << "\\ |  a  |  b  |  c  |" << std::endl << std::setprecision(2)
    << "a |  -  | " << normal_correlate(a, b, arraySize(a)) << "|" << normal_correlate(a, c, arraySize(c)) << " |" << std::endl
    << "b | " << normal_correlate(b, a, arraySize(b)) << "|  -  |" << normal_correlate(b, c, arraySize(c)) << " |" << std::endl
    << "c | " << normal_correlate(c, a, arraySize(c)) << "| " << normal_correlate(c, b, arraySize(c)) << "|  -  |" << std::endl;
}
