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
"("         { return LPAREN; }
")"         { return  RPAREN; }
","         { return COMMA; }
";"         { return SEMICOLON; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"return"    { return RETURN; }
"="         { return ASSIGN; }
[a-zA-Z_][a-zA-Z_0-9]*  {yylval.id = strdup(yytext); return IDENT; }
[0-9]*\.[0-9]+          {yylval.float_val = atof(yytext); return FLOAT_LITERAL; }
[0-9]+                  {yylval.int_val = atoi(yytext); return INT_LITERAL; }
[ \t\n]+     {}
.           {fprintf(stderr, "Line %d:Unkown character '%c'\n", yylineno, yytext[0]); }
%%

int yywrap() {
    return 1;
}
