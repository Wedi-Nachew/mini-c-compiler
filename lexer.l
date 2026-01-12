%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "parser.tab.h"
%}

%option yylineno

%%
"int"       { return INT; }
"float"     { return FLOAT; }
"void"      { return VOID; }
"return"    { return RETURN; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"do"        { return DO; }
"for"       { return FOR; }
"continue"  { return CONTINUE; }
"break"     { return BREAK; }
"||"        { return OR; }
"&&"        { return AND; }
"!="        { return NEQ; }
"=="        { return EQ; }
"<="        { return LEQ; }
">="        { return GEQ; }
"<"         { return LT; }
">"         { return GT; }
"++"        { return INC; }
"--"        { return DEC; }
"+="        { return ADD_ASSIGN; }
"-="        { return SUB_ASSIGN; }
"*="        { return MUL_ASSIGN; }
"/="        { return DIV_ASSIGN; }
"="         { return ASSIGN; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return STAR; }
"/"         { return SLASH; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
","         { return COMMA; }
";"         { return SEMICOLON; }

[0-9]*\.[0-9]+          { yylval.float_val = atof(yytext); return FLOAT_LITERAL; }
[0-9]+                  { yylval.int_val = atoi(yytext); return INT_LITERAL; }
\"([^\\\n]|(\\.))*\"    { yylval.str_val = strdup(yytext); return STRING_LITERAL; }
[a-zA-Z_][a-zA-Z_0-9]*  { yylval.id = strdup(yytext); return IDENT; }

[ \t\n]+                {}
.                    { fprintf(stderr, "Line %d: Unknown character '%c'\n", yylineno, yytext[0]); }
%%

int yywrap() {
    return 1;
}
