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
[a-zA-Z_][a-zA-Z_0-9]*  {yylval.id = strdup(yytext); return IDENT;}
[ \t\n]+     {}
.           {printf("Unknown Character: '%c'\n", yylineno, yytext[0]);}
%%

int yywrap() {
    return 1;
}
