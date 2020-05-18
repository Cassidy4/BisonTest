//
// Created by kamila on 14.01.2020.
//

#ifndef BISONTEST_PARAM_HPP
#define BISONTEST_PARAM_HPP

#include <string>
#include <map>
#include <cmath>
#include <vector>
#include <exception>


extern int yylineno;

struct MyException : public std::exception
{
    std::string msg;
    MyException(std::string m){
        msg = m;
    }
    const char * what () const throw ()
    {
        return "C++ Exception";
    }
};

struct given{
    long long num = 0;
    std::string str = "";
    bool type = 0; //zero -> int |one-> str
    bool array = false;
    bool indexId = false;
     long long arrayIndex = NAN;
     long long arrayIndexAdd = NAN;
    long long num2 = 0;
};

struct arrayInfo {
     long long addr = -1;
     long long first = -1;
     long long size = -1;

    arrayInfo( long long addr,  long long first,  long long size) {
        this->addr = addr;
        this->first = first;
        this->size = size;
    }
    arrayInfo()= default;
};

extern std::map<std::string,  long long> variables;
extern std::map<std::string,  long long> forVar;
extern std::map<std::string, arrayInfo> arrays;
extern std::vector<std::string> allLines;

extern const  long long resR;
extern  long long curR;


extern  long long lastInxId;
extern  long long lastInxAddId ;
extern  long long lastIfId;
extern  long long timesId;

extern  long long oneId;
extern  long long mOneId;

extern long long backUpMemory;


extern std::map<std::string,  long long> inited;

#endif //BISONTEST_PARAM_HPP
