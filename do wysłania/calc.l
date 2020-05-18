%option noyywrap
%option yylineno
%{
#include <string>
struct given{
	long long num = 0;
	std::string str = "";
	bool type = 0; //zero -> int |one-> str
};
#define YYSTYPE given
#include "calc_y.hpp"


int yylex();
int yyerror(char*);

%}

%%
\[[^\[\]]*\]   ;
[ \t]+ 	;
"-"?[0-9]+ 	{ yylval.num = atoi(yytext); yylval.type = 0; return NUM; }
[_a-z]+ { yylval.str = yytext; yylval.type = 1; return PID;}
"DECLARE"	{ return DECLARE; }
"BEGIN" 	{ return BEG; }
"END"	{ return END; }
"ASSIGN" { return ASSIGN; }
"PLUS"  {return PLUS; }
"MINUS"  {return MINUS; }
"TIMES" {return TIMES; }
"DIV"   {return DIV;}
"MOD"   {return MOD;}
"WRITE" {return WRITE; }
"READ"  {return READ; }
"IF"    {return IF;}
"THEN"  {return THEN;}
"ELSE"  {return ELSE;}
"ENDIF" {return ENDIF;}
"EQ"   {return EQ;}
"NEQ"   {return NEQ;}
"LE"    {return LE;}
"GE"    {return GE;}
"LEQ"   {return LEQ;}
"GEQ"   {return GEQ;}
"NOP"   {return NOP;}
"WHILE" {return WHILE;}
"DO"    {return DO;}
"ENDWHILE"  {return ENDWHILE;}
"ENDDO"  {return ENDDO;}
"FOR"   {return FOR;}
"FROM"  {return FROM;}
"TO"    {return TO;}
"DOWNTO"    {return DOWNTO;}
"ENDFOR"    {return ENDFOR;}
";"     {return SEMICO;}
","     {return COMA;}
"("     {return OPENB;}
")"     {return CLOSEB;}
":"     {return COLON;}
\n  ;
.	{ yyerror(yytext);}
%%