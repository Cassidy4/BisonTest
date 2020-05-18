//
// Created by kamila on 14.01.2020.
//
#include <string>
#include <iostream>
#include "Param.hpp"
#include "Operand.hpp"
#include "MakeNum.hpp"

using namespace std;

void makeOne() {
    allLines.emplace_back("SUB 0");
    allLines.emplace_back("INC");
    allLines.emplace_back("STORE " + to_string(oneId));
}

void load(long long id) {
    //if (allLines.back() != ("STORE " + to_string(id))) {
        allLines.push_back("LOAD " + to_string(id));
    //}
}

void store(long long id) {
    allLines.push_back("STORE " + to_string(id));
}

void loadi(long long id) {
    allLines.push_back("LOADI " + to_string(id));
}

void storei(long long id) {
    allLines.push_back("STOREI " + to_string(id));
}


void add(long long id) {
    allLines.push_back("ADD " + to_string(id));
}

void sub(long long id) {
    allLines.push_back("SUB " + to_string(id));
}

void mult() {
    long long fJump = allLines.size();
    jzero(); //14
    store(timesId + 1);//15
    shift(mOneId); //16
    store(timesId + 2); //17
    load(timesId + 1);
    sub(timesId + 2);
    sub(timesId + 2);
    jzero();
    allLines.back() += to_string(allLines.size() + 11);
    load(timesId + 2);
    jneg();
    allLines.back() += to_string(allLines.size() + 4);
    load(timesId + 3);
    add(timesId);
    jump();
    allLines.back() += to_string(allLines.size() + 5);
    load(timesId + 2);
    inc();
    store(timesId + 2);
    load(timesId + 3);
    sub(timesId);
    store(timesId + 3);
    load(timesId);
    shift(oneId);
    store(timesId);
    load(timesId + 2);
    jump();
    allLines.back() += to_string(fJump);
    allLines[fJump] += to_string(allLines.size());
    load(timesId + 3);
}

void beforeDM() {
    store(timesId);
    jpos();
    allLines.back() += to_string(allLines.size() + 8);
    jzero();
    allLines.back() += to_string(allLines.size() + 7);
    sub(0);
    sub(timesId);
    store(timesId);
    load(oneId);
    store(timesId + 4);
    sub(0);
    jump();
    allLines.back() += to_string(allLines.size() + 2);
    sub(0);
    store(timesId + 4);
    store(timesId + 3);
    inc();
    store(timesId + 2);
}

void divMod(int ad) {
    store(timesId + 1);
    store(timesId + 5);
    jzero();
    allLines.back() += to_string(allLines.size() + 1);
    jump();
    allLines.back() += to_string(allLines.size() + 3);
    sub(0);
    store(timesId);
    jump();
    allLines.back() += to_string(allLines.size() + 46 + ad);
    jpos();
    allLines.back() += to_string(allLines.size() + 7);
    sub(0);
    sub(timesId + 1);
    store(timesId + 1);
    load(timesId + 4);
    dec();
    store(timesId + 4);
    load(timesId + 1);
    sub(timesId);
    jpos();
    allLines.back() += to_string(allLines.size() + 9);
    jzero();
    allLines.back() += to_string(allLines.size() + 8);
    add(timesId);
    shift(oneId);
    store(timesId + 1);
    load(timesId + 2);
    shift(oneId);
    store(timesId + 2);
    load(timesId + 1);
    jump();
    allLines.back() += to_string(allLines.size() - 11);
    load(timesId + 1);
    sub(timesId);
    jpos();
    allLines.back() += to_string(allLines.size() + 6);
    load(timesId);
    sub(timesId + 1);
    store(timesId);
    load(timesId + 3);
    add(timesId + 2);
    store(timesId + 3);
    load(timesId + 1);
    shift(mOneId);
    store(timesId + 1);
    load(timesId + 2);
    shift(mOneId);
    store(timesId + 2);
    jzero();
    allLines.back() += to_string(allLines.size() + 1);
    jump();
    allLines.back() += to_string(allLines.size() - 17);
}

void shift(long long id) {
    allLines.push_back("SHIFT " + to_string(id));
}

void put() {
    allLines.emplace_back("PUT");
}

void get() {
    allLines.emplace_back("GET");
}

void inc() {
    allLines.emplace_back("INC");
}

void dec() {
    allLines.emplace_back("DEC");
}


void jump() {
    allLines.emplace_back("JUMP ");
}

void jpos() {
    allLines.emplace_back("JPOS ");
}

void jzero() {
    allLines.emplace_back("JZERO ");
}

void jneg() {
    allLines.emplace_back("JNEG ");
}

void halt() {
    allLines.emplace_back("HALT");
}

void printAll() {
    for (const auto &allLine : allLines) {
        cout << allLine << "\n";
    }
}

void condition(given &$$, given &$3, Jump op) {
    if ($3.indexId) { load($3.arrayIndexAdd); }
    store(lastIfId);
    if ($3.type) {
        if ($3.array) {
            arrayInfo a = arrays[$3.str];
            if (a.addr == -1) {
                cerr << "Error2" << endl;
                return; //TODO
            } else {
                if ($3.indexId) {
                    loadi($3.arrayIndex);
                } else {
                    long long addres = (a.addr + $3.arrayIndex - a.first);
                    load(addres);
                }
            }
        } else {
            if (variables[$3.str] == 0) {
                load(forVar[$3.str]);
            } else {
                load(variables[$3.str]);
            }
        }
    } else {
        produce($3.num);
    }
    sub(lastIfId);
    switch (op) {
        case Jump::JZERO :
            jzero();
            break;
        case Jump::JPOS :
            jpos();
            break;
        case Jump::JNEG :
            jneg();
            break;
    }
    $$.arrayIndex = allLines.size() - 1;
}

void conditionF(given &$$, long long backUp, Jump op) {
    store(lastIfId);

    load(backUp);

    sub(lastIfId);
    switch (op) {
        case Jump::JZERO :
            jzero();
            break;
        case Jump::JPOS :
            jpos();
            break;
        case Jump::JNEG :
            jneg();
            break;
    }
    $$.arrayIndex = allLines.size() - 1;
}


void negCondition(given &$$, given &$3, Jump op) {
    if ($3.indexId) { load($3.arrayIndexAdd); }
    store(lastIfId);
    if ($3.type) {
        if ($3.array) {
            arrayInfo a = arrays[$3.str];
            if (a.addr == -1) {
                cerr << "Error2" << endl;
                return;
            } else {
                if ($3.indexId) {
                    loadi($3.arrayIndex);
                } else {
                    long long addres = (a.addr + $3.arrayIndex - a.first);
                    load(addres);
                }
            }
        } else {
            if (variables[$3.str] == 0) {
                load(forVar[$3.str]);
            } else {
                load(variables[$3.str]);
            }
        }
    } else {
        produce($3.num);
    }
    sub(lastIfId);
    jzero();
    allLines.back() += to_string(allLines.size() + 1);
    jump();
    $$.arrayIndex = allLines.size() - 1;
}

void conditionP(given &$$, given &$3, Jump op) {
    if ($3.indexId) { load($3.arrayIndexAdd); }
    store(lastIfId);
    if ($3.type) {
        if ($3.array) {
            arrayInfo a = arrays[$3.str];
            if (a.addr == -1) {
                cerr << "Error2" << endl;
                return; //TODO
            } else {
                if ($3.indexId) {
                    loadi($3.arrayIndex);
                } else {
                    long long addres = (a.addr + $3.arrayIndex - a.first);
                    load(addres);
                }
            }
        } else {
            if (variables[$3.str] == 0) {
                load(forVar[$3.str]);
            } else {
                load(variables[$3.str]);
            }
        }
    } else {
        produce($3.num);
    }
    sub(lastIfId);
    switch (op) {
        case Jump::JPOS :
            allLines.emplace_back("INC");
            jpos();
            break;
        case Jump::JNEG :
            allLines.emplace_back("DEC");
            jneg();
            break;
    }
    $$.arrayIndex = allLines.size() - 1;
}

void assaign(given &$1) {
    if ($1.array) {
        arrayInfo a = arrays[$1.str];
        if (a.addr == -1) {
            cerr << $1.str << "Error1" << endl;
            return;
        } else {
            if ($1.indexId) {
                storei($1.arrayIndex);
            } else {
                unsigned long long addres = (a.addr + $1.arrayIndex - a.first);
                store(addres);
            }
        }
    } else {
        if (variables[$1.str] == 0) {
            throw MyException("Błąd w linii " + to_string(yylineno - 1) + ": niezadeklarowana zmienna " + $1.str);


            return;
        } else {
            store(variables[$1.str]);
        }
    }
}
