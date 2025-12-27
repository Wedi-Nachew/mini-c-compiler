%{
    #include <stdio.h>
    #include <stdlib.h>

    void yyerror(const char *s);
    int yylex(void);
    extern int yylineno;
    extern char *yytext; /* current token text for error messages */
%}

%define parse.error verbose /* ask bison/yacc to produce richer syntax errors */

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

%token ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN
%token PLUS MINUS STAR SLASH
%token LT GT LE GE EQ NEQ
%token AND OR NOT
%token DEC INC


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
        | type_spec IDENT LPAREN error RPAREN SEMICOLON
            { yyerror("Malformed parameter list in function declaration"); yyerrok; }
        | type_spec IDENT LPAREN error RPAREN compound_stmt
            { yyerror("Malformed parameter list in function definition"); yyerrok; }
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
        | LBRACE error RBRACE
            { yyerror("Error inside block; skipped to '}'"); yyerrok; }
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
        : assignment_expr 
        ;
    
    assignment_expr
        : IDENT ASSIGN assignment_expr
        | IDENT ADD_ASSIGN assignment_expr
        | IDENT SUB_ASSIGN assignment_expr
        | IDENT MUL_ASSIGN assignment_expr
        | IDENT DIV_ASSIGN assignment_expr
        | logical_or_expr
        ;

    logical_or_expr
        : logical_or_expr OR logical_and_expr
        | logical_and_expr
        ;

    logical_and_expr
        : logical_and_expr AND equality_expr
        | equality_expr
        ;
    
    equality_expr
        : equality_expr EQ relational_expr
        | equality_expr NEQ relational_expr
        | relational_expr
        ;
    
    relational_expr
        : relational_expr LT additive_expr
        | relational_expr GT additive_expr
        | relational_expr LE additive_expr
        | relational_expr GE additive_expr
        | additive_expr
        ;

    additive_expr
        : additive_expr PLUS multiplicative_expr
        | additive_expr MINUS multiplicative_expr
        | multiplicative_expr
        ;
    
    multiplicative_expr
        : multiplicative_expr STAR unary_expr
        | multiplicative_expr SLASH unary_expr
        | unary_expr
        ;
    
    unary_expr
        : MINUS unary_expr
        | NOT unary_expr
        | INC unary_expr
        | DEC unary_expr
        | postfix_expr
        ;
    
    postfix_expr
        : primary_expr
        | postfix_expr INC
        | postfix_expr DEC
        ;
    
    primary_expr
        : IDENT
        | IDENT LPAREN opt_arg_list RPAREN
        | INT_LITERAL
        | FLOAT_LITERAL
        | LPAREN expr RPAREN
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

    arg_list
        : expr
        | arg_list COMMA expr
        ;
    
    opt_arg_list
        : %empty
        | arg_list
        ;
%%

int main() {
    printf("Parser started parsing\n");
    yyparse();
}

void yyerror(const char *s) {
    /* include yytext to highlight the unexpected token when available */
    fprintf(stderr, "Line %d near '%s': %s\n", yylineno, yytext ? yytext : "<eof>", s);
}