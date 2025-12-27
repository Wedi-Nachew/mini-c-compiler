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
%token IF ELSEIF ELSE
%token WHILE DO FOR
%token CONTINUE BREAK

%token ASSIGN
%token PLUS MINUS STAR SLASH

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
    
    stmt_list
        : %empty
        | stmt
        | stmt_list stmt
        ;
    
    stmt
        : matched_stmt
        | unmatched_stmt
        | error SEMICOLON
            { yyerror("Invalid statement"); yyerrok; }
        ;
    
    matched_stmt
        : other_stmt
        | IF LPAREN expr RPAREN matched_stmt ELSE matched_stmt
        ;
    
    unmatched_stmt
        : IF LPAREN expr RPAREN stmt
        | IF LPAREN expr RPAREN matched_stmt ELSE unmatched_stmt 
        ;

    other_stmt
        : SEMICOLON
        | return_stmt
        | assign_stmt
        | variable_decl_stmt
        | compound_stmt
        | while_stmt
        | do_while_stmt
        | for_stmt
        | continue_stmt
        | break_stmt
        ;
    
    compound_stmt
        : LBRACE stmt_list RBRACE
        ;

    return_stmt
        : RETURN SEMICOLON
        | RETURN expr SEMICOLON
        ;
    
    variable_decl_stmt
        : type_spec IDENT SEMICOLON
        ;
    
    assign_stmt
        : IDENT ASSIGN expr SEMICOLON
        ;
    
    expr
        : additive_expr 
        ;
    
    additive_expr
        : additive_expr PLUS multiplicative_expr
        | additive_expr MINUS multiplicative_expr
        | multiplicative_expr
        ;
    
    multiplicative_expr
        : multiplicative_expr STAR primary_expr
        | multiplicative_expr SLASH primary_expr
        | primary_expr
        ;
    
    primary_expr
        : IDENT
        | INT_LITERAL
        | FLOAT_LITERAL
        | RPAREN expr LPAREN
        ;

    while_stmt
        : WHILE LPAREN expr RPAREN stmt
        ;

    do_while_stmt
        : DO stmt WHILE LPAREN expr RPAREN SEMICOLON
        ;

    for_stmt
        : FOR LPAREN opt_expr SEMICOLON opt_expr SEMICOLON opt_expr RPAREN stmt
        ;
    
    opt_expr
        : %empty
        | expr
        ;
    
    continue_stmt
        : CONTINUE SEMICOLON
        ;
    
    break_stmt
        : BREAK SEMICOLON
        ;
%%

int main() {
    printf("Parser started parsing\n");
    yyparse();
}

void yyerror(const char *s) {
    fprintf(stderr, "Line %d: %s\n", yylineno, s);
}