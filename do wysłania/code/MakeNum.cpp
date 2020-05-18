//
// Created by kamila on 14.01.2020.
//
#include <stack>
#include <iostream>
#include "Operand.hpp"
#include "Param.hpp"
#include "MakeNum.hpp"

using namespace std;

void preparePlace(given &a, given &b) {
    if(allLines.back()[0] != 'S' || allLines.back()[1] != 'T'|| allLines.back()[2] != 'O' || allLines.back()[3] != 'R'|| allLines.back()[4] != 'E'){
        a.arrayIndexAdd = lastInxAddId;
        store(lastInxAddId++);
    }
    arrayInfo arIn = arrays[a.str];
    long long bIndex = variables[b.str];
    if(bIndex == 0){
        bIndex = forVar[b.str];
    }
    load(bIndex);
    //TODO error (jeśli wartość przechowywana w b nie należy do tablicy)
    increases(arIn.addr - arIn.first);

    store(a.arrayIndex);
}

void loadVal(given& $2){
    if($2.type){
        if($2.array){
            arrayInfo a = arrays[$2.str];
            if(a.addr == -1){ cerr << "Error2" << endl; return ;}else{
                if($2.indexId){
                    loadi($2.arrayIndex);
                }
                else{
                    long long addres = (a.addr + $2.arrayIndex - a.first);
                    load(addres);}}}
        else{
            if(variables[$2.str] == 0){
                load(forVar[$2.str]);
            }
            else{
                load(variables[$2.str]);}}}
    else{
        if(allLines.back() == "STORE " + to_string(oneId)){increases($2.num - 1);}
        else{produce($2.num);}}
}

void smallIncreases(long long nr) {
    if (nr > 0) {
        for (long long i = 0; i < nr; ++i) {
            allLines.emplace_back("INC");
        }

    } else {
        for (long long i = 0; i > nr; i--) {
            allLines.emplace_back("DEC");
        }
    }
}

void increases(long long nr) {
    if (nr < 30 && nr > -30) {
        smallIncreases(nr);
    } else if (nr > 0) {
        allLines.emplace_back("STORE 1");
        produce(nr);
        allLines.emplace_back("ADD 1");
    } else {
        allLines.emplace_back("STORE 1");
        produce(-nr);
        allLines.emplace_back("STORE 2");
        allLines.emplace_back("LOAD 1");
        allLines.emplace_back("SUB 2");
    }
}

void smallProduce(long long nr) {
    if (nr < 8) {
        if (nr != 0) {
            if (nr > 0 || allLines.back() == "STORE " + to_string(oneId)) {
                load(oneId);
                increases(nr - 1);
            } else {
                allLines.emplace_back("SUB 0");
                increases(nr);
            }
        } else {
            allLines.emplace_back("SUB 0");
        }
    } else {
        load(oneId);
        allLines.emplace_back("INC");
        int k = 2;
        long long pot = (1 << 2) * 2;
        long long pn = (1 << (2 + 1)) * 3;
        while (pot < nr) {
            if (nr < pn) {
                if ((nr <= pot * 2) || (k + 10 + (nr - pot * 2) < k + 6 + (pn - nr))) {
                    break;
                }
            }
            allLines.emplace_back("INC");
            k++;
            pot = (1 << k) * k;
            pn = (1 << (k + 1)) * k;
        }
        pot = (1 << k) * k;


        allLines.emplace_back("SHIFT 0");
        if (nr < pot) {
            increases(nr - pot);
        } else if (nr > pot) {
            if (nr < pot * 2) {
                if (nr - pot <= 5 + (pot * 2) - nr) {
                    increases(nr - pot);
                } else {
                    allLines.emplace_back("SHIFT " + to_string(oneId));
                    increases(nr - pot * 2);
                }
            } else {
                allLines.emplace_back("SHIFT " + to_string(oneId));
                increases(nr - pot * 2);
            }
        }
    }
}

void produce(long long nr) {
    if (nr < 44) {
        smallProduce(nr);
    } else {
        stack<pair<string, int>> s;
        while (nr >= 44) {
            if (nr % 2 == 0) {
                if (s.size() == 0 || s.top().first != "SHIFT " + to_string(oneId)) {
                    s.push({"SHIFT " + to_string(oneId), 1});
                } else {
                    s.top().second += 1;
                }
                nr /= 2;
            } else {
                s.push({"INC", 0});
                nr--;
            }
        }
        smallProduce(nr);
        while (s.size()) {
            for (int i = 1; i < s.top().second; i++) {
                allLines.emplace_back(s.top().first);
            }
            allLines.emplace_back(s.top().first);
            s.pop();
        }
    }
}

