//
// Created by kamila on 14.01.2020.
//

#ifndef BISONTEST_OPERAND_HPP
#define BISONTEST_OPERAND_HPP

#include "Param.hpp"

void makeOne();
void load(long long id);
void store(long long id);

void loadi(long long id);
void storei(long long id);

void add(long long id);
void sub(long long id);
void mult();
void divMod(int ad);
void beforeDM();


void shift(long long id);

void put();
void get();

void inc();
void dec();

void jump();
void jpos();
void jzero();
void jneg();
void halt();
void printAll();

enum class Jump{
    JZERO, JPOS, JNEG
};


void condition(given& $$, given& $3, Jump op);
void negCondition(given &$$, given &$3, Jump op);
void conditionP(given &$$, given &$3, Jump op);
void conditionF(given& $$, long long backUp, Jump op);

void assaign(given &$1);


#endif //BISONTEST_OPERAND_HPP
