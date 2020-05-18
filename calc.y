%{
#define YYSTYPE given
#include<stdio.h>
#include<iostream>
#include<stack>
#include<map>
#include <math.h>
#include <string>
#include <utility>
#include "code/Operand.hpp"
#include "code/Param.hpp"
#include "code/MakeNum.hpp"

using namespace std;

bool valueWasArray = false;
bool idWasArray = false;
long long valueArrayIndex = -1;
long long idArrayIndex = -1;


unsigned long long addres = 0;
arrayInfo a;

int yylex();
int yyerror(char*);

%}
%token NUM
%token PID
%token SEMICO
%token COMA
%token OPENB
%token CLOSEB
%token COLON
%token DECLARE
%token BEG
%token END
%token ASSIGN

%token PLUS
%token MINUS
%token TIMES
%token MOD
%token DIV

%token WRITE
%token READ

%token IF
%token THEN
%token ELSE
%token ENDIF

%token WHILE
%token DO
%token ENDDO
%token ENDWHILE


%token NEQ
%token EQ
%token LE
%token GE
%token LEQ
%token GEQ

%token FOR
%token FROM
%token TO
%token DOWNTO
%token ENDFOR

%token ERROR
%token NOP
%%
program: DECLARE declarations BEG commands END {halt();}
    | BEG commands END {halt();}
;
declarations:  declarations COMA PID {
		if(variables[$3.str] != 0){
		throw MyException("Błąd w linii " + to_string(yylineno - 1) + ": druga deklaracja " + $3.str);}
		variables[$3.str]  = curR++;}
	|	declarations COMA PID OPENB num COLON num CLOSEB {
		if($5.num > $7.num){throw MyException("Błąd w linii " + to_string(yylineno) + ": niewłaściwy zakres tablicy " + $3.str);}
		arrays.insert(pair<string, arrayInfo>($3.str, arrayInfo(curR++, $5.num, ($7.num - $5.num)))); curR +=($7.num - $5.num);}
	|	PID {
		if(variables[$1.str] != 0){
            	throw MyException("Błąd w linii " + to_string(yylineno - 1) + ": druga deklaracja " + $1.str);}
		variables[$1.str] = curR++;}
	|	PID OPENB num COLON num CLOSEB {
		if($3.num > $5.num){throw MyException("Błąd w linii " + to_string(yylineno) + ": niewłaściwy zakres tablicy " + $1.str);}
		arrays.insert(pair<string, arrayInfo>($1.str, arrayInfo(curR++, $3.num, ($5.num - $3.num)))); curR += ($5.num - $3.num);}
;
commands: commands command {}
	| command
;

command: identifierI ASSIGN expression semico {assaign($1);}
	| IF condition THEN commands ENDIF {allLines[$2.arrayIndex] += to_string(allLines.size());}
	| IF condition THEN commands else commands ENDIF {allLines[$2.arrayIndex] += to_string($5.arrayIndexAdd);
							allLines[$5.arrayIndex] += to_string(allLines.size());}
	| while condition DO commands ENDWHILE {allLines[$2.arrayIndex] += to_string(allLines.size()+1);
						jump(); allLines.back() += to_string($1.arrayIndex+1);}
	| dop commands while negcondition ENDDO {allLines[$4.arrayIndex] += to_string($1.arrayIndex);}
	| fromex DO commands ENDFOR {
					load(forVar[$1.str]);
					inc();
					store(forVar[$1.str]);
					jump(); allLines.back() += to_string($1.arrayIndexAdd);
					allLines[$1.arrayIndex] += to_string(allLines.size());
	 				forVar[$1.str] = 0;
				//allLines.push_back(to_string(arrays[$1.str].addr)+to_string(variables[$1.str]) + to_string(forVar[$1.str]));$$ = $1;

	 				}
	| fromexdown DO commands ENDFOR {
					load(forVar[$1.str]);
					dec();
					store(forVar[$1.str]);
					if($1.indexId){
					load($1.num2); store($1.num);}
					jump(); allLines.back() += to_string($1.arrayIndexAdd);
					allLines[$1.arrayIndex] += to_string(allLines.size());
					forVar[$1.str] = 0; }
	| WRITE value semico {if($2.type){
				if($2.array){
					a = arrays[$2.str];
					if(a.addr == -1){ cerr << "Error2" << endl; return 0;}else{
					if($2.indexId){
						loadi($2.arrayIndex);
						put();
					}
					else{
						addres = (a.addr + $2.arrayIndex - a.first);
						load(addres);
						put();}}}
				else{
					if(variables[$2.str] == 0){
						load(forVar[$2.str]);
                                                put();
					}
					else{
						load(variables[$2.str]);
						put();}}}
				else{
				if(allLines.back() == "STORE " + to_string(oneId)){increases($2.num - 1);}
				else{produce($2.num);}
				put();}}
	| READ identifierI semico {if($2.array){
					a = arrays[$2.str];
					if(a.addr == -1){ cerr << "Error2" << endl; return 0;}else{
					if($2.indexId){
						loadi($2.arrayIndex);
						get();
						storei($2.arrayIndex);
					}
					else{
					get();
					addres = (a.addr + $2.arrayIndex - a.first);
					store(addres);
					}}}
				else{
					if(variables[$2.str] == 0){
						if(forVar[$2.str] == 0){
							throw MyException("Błąd w linii " + to_string(yylineno) + ": niezadeklarowana zmienna " + $2.str);
						}
						else{
							get();
							store(forVar[$2.str]);
						}
					}
					else{
						get();
						store(variables[$2.str]);}}}
	| NOP

;
expression: valuel
	| valuel PLUS valuep {if($3.type){
					if($3.array){
						a = arrays[$3.str];
						if(a.addr == -1){ cerr << "Error2" << endl; return 0;}else{
						if($3.indexId){
							loadi($3.arrayIndex);
							add($3.arrayIndexAdd);
						}
						else{
							addres = (a.addr + $3.arrayIndex - a.first);
							add(addres);}}}
					else{
						if(variables[$3.str] == 0){
							add(forVar[$3.str]);
						}
						else{
							add(variables[$3.str]);}
					}}
				else {increases($3.num);}}
	| valuel TIMES valuep {
				if($3.array && $3.indexId){ load($3.arrayIndexAdd);}
				store(timesId);
				sub(0); store(timesId + 3);
	 			loadVal($3); mult();}
	| valuel DIV valuep {
				if($3.array && $3.indexId){ load($3.arrayIndexAdd);}
				beforeDM();
				loadVal($3); divMod(0);
				load(timesId + 4);
				jzero();
				allLines.back() += to_string(allLines.size() + 7);//TODO
				load(timesId + 3);
				inc(); store(timesId + 3);
				sub(0); sub(timesId + 3);
				store(timesId + 3);
				jump(); allLines.back() += to_string(allLines.size() + 1);
				load(timesId + 3);}
	| valuel MOD valuep {
				if($3.array && $3.indexId){ load($3.arrayIndexAdd);}
				beforeDM();
				loadVal($3); divMod(5);
				sub(0);
				sub(timesId + 5);
				jneg();
				allLines.back() += to_string(allLines.size() + 3);
				sub(0);
				sub(timesId);
				store(timesId);

				load(timesId + 4);
				jzero();
				allLines.back() += to_string(allLines.size() + 7);
				load(timesId);
				sub(timesId + 5);
				store(timesId);
				sub(0);
				sub(timesId);
				store(timesId);
				jump();
				allLines.back() += to_string(allLines.size() + 1);

				load(timesId);}

	| valuel MINUS valuep {if($3.type){
					if($3.array){
						a = arrays[$3.str];
						if(a.addr == -1){ cerr << "Error2" << endl; return 0;}else{
						if($3.indexId){
							long long u = lastInxAddId++;
							loadi($3.arrayIndex);
							store(u);
							load($3.arrayIndexAdd);
							sub(u);
						}
						else{
							addres = (a.addr + $3.arrayIndex - a.first);
							sub(addres);}}}
					else{
						if(variables[$3.str] == 0){
							sub(forVar[$3.str]);
						}
						else{
							sub(variables[$3.str]);}}}
                              	else{increases(-$3.num);}}
;
condition:	valuel NEQ valuep {condition($$, $3, Jump::JZERO);}
		| valuel EQ valuep {negCondition($$, $3, Jump::JZERO);}
		|valuel GEQ valuep {condition($$, $3, Jump::JPOS);}
		|valuel LEQ valuep {condition($$, $3, Jump::JNEG);}
		|valuel LE valuep {conditionP($$, $3, Jump::JNEG);}
		|valuel GE valuep {conditionP($$, $3, Jump::JPOS);}
;
negcondition:	valuel EQ valuep {condition($$, $3, Jump::JZERO);}
   		| valuel NEQ valuep {negCondition($$, $3, Jump::JZERO);}
   		|valuel LEQ valuep {conditionP($$, $3, Jump::JPOS);}
   		|valuel GEQ valuep {conditionP($$, $3, Jump::JNEG);}
   		|valuel GE valuep {condition($$, $3, Jump::JNEG);}
   		|valuel LE valuep {condition($$, $3, Jump::JPOS);}
;
valuel: value {	if (!$1.type) { produce($1.num); }
                   else {
                       if ($1.array) {
                           a = arrays[$1.str];
                           if (a.addr == -1) {
                               cerr << "Error3" << endl;
                               return 0;
                           }
                           else {
                           	if($1.indexId){loadi($1.arrayIndex);}
                           	else{
				       addres = (a.addr + $1.arrayIndex - a.first);
				       load(addres);
                               	}
                           }
                       } else {
                        	if(variables[$1.str] == 0){
                        		if(forVar[$1.str] == 0){
						throw MyException("Błąd w linii " + to_string(yylineno) + ": niezadeklarowana zmienna " + $1.str);
                        		}
                        		else{
						load(forVar[$1.str]);
					}
				}
				else{
					load(variables[$1.str]);}}
                   }$$ = $1;}

;
valuep: value {}
;
else: ELSE {jump(); $$.arrayIndex = allLines.size()-1; $$.arrayIndexAdd = allLines.size(); }
;
while: WHILE {$$.arrayIndex = allLines.size()-1;};
dop: DO{inc(); $$.arrayIndex = allLines.size();};
forex: FOR pidentifier {forVar[$2.str] = curR++; $$ = $2;}
;
fromex: forex FROM valuel TO valuep{ if($5.array && $5.indexId){loadi($5.arrayIndex); store(backUpMemory); load($5.arrayIndexAdd);}
					store(forVar[$1.str]);
					if($5.indexId == false){
					    if ($5.type) {
						if ($5.array) {
						    arrayInfo a = arrays[$5.str];
						    if (a.addr == -1) {
							cerr << "Error2" << endl;
							return 0; //TODO
						    } else {
							 long long addres = (a.addr + $5.arrayIndex - a.first);
							 load(addres);
						    }
						} else {
						    if (variables[$5.str] == 0) {
							load(forVar[$5.str]);
						    } else {
							load(variables[$5.str]);
						    }
						}
					    } else {
						produce($5.num);
					    }

					     store(backUpMemory);
					}
					else{
					inc();}
					load(forVar[$1.str]);


					$$.num2 = backUpMemory++;
					$$.str = $1.str;
					$$.arrayIndexAdd = allLines.size() - 1;
					conditionF($$, $$.num2, Jump::JNEG);
					$$.num = $5.arrayIndex;
                                        $$.indexId = $5.indexId;}
;

fromexdown: forex FROM valuel DOWNTO valuep{ if($5.array && $5.indexId){loadi($5.arrayIndex); store(backUpMemory); load($5.arrayIndexAdd);}
					store(forVar[$1.str]);

					if($5.indexId == false){
					    if ($5.type) {
						if ($5.array) {
						    arrayInfo a = arrays[$5.str];
						    if (a.addr == -1) {
							cerr << "Error2" << endl;
							return 0; //TODO
						    } else {
							 long long addres = (a.addr + $5.arrayIndex - a.first);
							 load(addres);
						    }
						} else {
						    if (variables[$5.str] == 0) {
							load(forVar[$5.str]);
						    } else {
							load(variables[$5.str]);
						    }
						}
					    } else {
						produce($5.num);
					    }

					     store(backUpMemory);
					}
					else{
					inc();}

					load(forVar[$1.str]);
					$$.num2 = backUpMemory++;
					$$.str = $1.str;
					$$.arrayIndexAdd = allLines.size() - 1;
					conditionF($$, $$.num2, Jump::JPOS);}
;

value: num {	}
    | identifier {if(inited[$1.str] == 0 && forVar[$1.str] == 0){
    throw MyException("Błąd w linii " + to_string(yylineno) + ": użycie niezainicjalizowanej zmiennej " + $1.str);
    }$$ = $1;}
;
identifierI : identifier { inited[$1.str] = 1;	$$ = $1;};
identifier: pidentifier {$1.array = false; $1.indexId = false; $1.arrayIndex = NAN;
 			if(arrays[$1.str].addr != -1)
 			{throw MyException("Błąd w linii " + to_string(yylineno) + ": niewłaściwe użycie zmiennej tablicowej " + $1.str);}

 			if(arrays[$1.str].addr == -1 && variables[$1.str] == 0 && forVar[$1.str] == 0){
			      throw MyException("Błąd w linii " + to_string(yylineno) + ": użycie niezadeklarowanej zmiennej " + $1.str);
			      }
				//allLines.push_back(to_string(arrays[$1.str].addr)+to_string(variables[$1.str]) + to_string(forVar[$1.str]));$$ = $1;

 			$$ = $1;}
	|	pidentifier OPENB pidentifier CLOSEB {$1.array = true; $1.indexId = true; $1.arrayIndex = lastInxId++; $$ = $1;
		preparePlace($1, $3);
 			if(variables[$1.str] != 0)
 			{throw MyException("Błąd w linii " + to_string(yylineno) + ": niewłaściwe użycie zmiennej " + $1.str);}

 			if(arrays[$3.str].addr == -1 && variables[$3.str] == 0 && forVar[$3.str] == 0){
		      throw MyException("Błąd w linii " + to_string(yylineno) + ": użycie niezadeklarowanej zmiennej " + $3.str);
		      }
			//allLines.push_back(to_string(arrays[$1.str].addr)+to_string(variables[$1.str]) + to_string(forVar[$1.str]));$$ = $1;


 			$$ = $1;}
	|	pidentifier OPENB num CLOSEB {$1.array = true; $1.indexId = false; $1.arrayIndex = $3.num;
 			if(variables[$1.str] != 0)
 			{throw MyException("Błąd w linii " + to_string(yylineno) + ": niewłaściwe użycie zmiennej " + $1.str);}
 			 $$ = $1;}
;

num: NUM {}
;
semico: SEMICO {lastInxId = 10; lastInxAddId = 30;}
;
pidentifier: PID {}
;

%%
int yyerror(char *s)
{
    throw MyException("Błąd w linii " + to_string(yylineno) + ": nierozpoznany napis " );
    return 0;
}

int main()
{
	sub(0);
	dec();
	store(mOneId);
	increases(2);
	store(oneId);
	//makeOne();

	try{
		yyparse();
		printAll();
	}
	catch(MyException& e){
		cout << e.msg << endl;
	}
	//printf("Przetworzono linii: %d\n",yylineno-1);

	return 0;
}