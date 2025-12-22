%{
    #include <stdio.h>
    #include <stdlib.h>

    void yyerror(const char *s);
    int yylex(void);
    extern int yylineno;
%}

%union{
    char *id;
    int  int_val;
    float float_val;
}

%token <id> IDENT
%token <int_val> INT_LITERAL
%token <float_val> FLOAT_LITERAL
%token INT FLOAT VOID
%token LPAREN RPAREN
%token COMMA SEMICOLON 
%token LBRACE RBRACE
%token RETURN
%token ASSIGN

%start program

%%
    program
        : function_list { printf("Parser finished successfully!\n");}
        ;
    
    function_list
        : function
        | function_list function
        ;
            
    function
        : type_spec IDENT LPAREN parameter_list RPAREN SEMICOLON
        | type_spec IDENT LPAREN parameter_list RPAREN compound_stmt
        | error SEMICOLON
            { yyerror("Invalid function declaration"); yyerrok; }
        | error compound_stmt
            { yyerror("Invalid function definition"); yyerrok; }
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
        ;
    
    parameter
        : type_spec IDENT
        ;
    
    compound_stmt
        : LBRACE stmt_list RBRACE
        ;
    
    stmt_list
        : %empty
        | stmt
        | stmt_list stmt
        ;
    
    stmt
        : SEMICOLON
        | return_stmt
        | variable_decl_stmt
        | assign_stmt
        | error SEMICOLON
            { yyerror("Invalid statement"); yyerrok; }
        ;
    
    return_stmt
        : RETURN SEMICOLON
        ;
    
    variable_decl_stmt
        : type_spec IDENT SEMICOLON
        ;
    
    assign_stmt
        : IDENT ASSIGN expr SEMICOLON
        ;
    
    expr
        : IDENT
        | INT_LITERAL
        | FLOAT_LITERAL
%%

int main() {
    printf("Parser started parsing\n");
    yyparse();
}

void yyerror(const char *s) {
    fprintf(stderr, "Line %d: %s\n", yylineno, s);
}