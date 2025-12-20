%{
    #include <stdio.h>
    #include <stdlib.h>

    void yyerror(const char *s);
    int yylex(void);
    extern int yylineno;
%}

%union{
    char *id;
}

%token <id> IDENT
%token INT FLOAT VOID
%token LPAREN RPAREN
%token COMMA SEMICOLON

%start program

%%
    program
        : function_list
        ;
    
    function_list
        : function
        | function_list function
        ;
            
    function
        : type_spec IDENT LPAREN parameter_list RPAREN SEMICOLON
        | error SEMICOLON
            { yyerror("Invalid function declaration"); }
        ;
    
    type_spec
        : INT
        | FLOAT
        | VOID
        ;

    parameter_list
        : %empty
        | parameter
        | parameter_list COMMA parameter
        | error
            { yyerror("Invalid parameter declaration") }
        ;
    
    parameter
        : type_spec IDENT
        ;
%%

int main() {
    printf("Compiler Started\n");
    yyparse();
}

void yyerror(const char *s) {
    fprintf(stderr, "Line %d: %s\n", yylineno, s);
}