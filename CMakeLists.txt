cmake_minimum_required(VERSION 3.15)
project(BisonTest)

set(CMAKE_CXX_STANDARD 17)

add_executable(BisonTest main.cpp code/MakeNum.hpp code/Operand.hpp code/Param.hpp code/Param.cpp code/Operand.cpp code/MakeNum.cpp)