# Mini-C-Compiler

## Group Members

1. Filmon Gebrelibanos UGR/170182/12
2. Mercury Desta EITM/TUR181533/16
3. Tekle Beyene UGR/170122/12
4. Samuel Tekeste EITM/TUR181591/16

## 1. Introduction

This project demonstrates core compiler phases—lexical analysis and syntax analysis—by designing a simple language and implementing its lexer and parser using flex and bison. Development was incremental with Git, adding and validating language features step by step with targeted test inputs.

## 2. Language Design (Implemented Grammar)

### 2.1 Overview

The language is a C-like imperative subset extended for experimentation. The parser recognizes:

-   Functions (declarations and definitions)
-   Variable declarations and assignments
-   Arithmetic, relational, and logical expressions
-   Conditionals (`if`, `else`)
-   Loops (`while`, `do-while`, `for`)
-   Control statements (`return`, `break`, `continue`)
-   Block statements (`{ ... }`)

### 2.2 Data Types

Primitive types: `int`, `float`, `void`. Semantic/type checking is out of scope.

### 2.3 Functions

Functions may be declared or defined with empty or non-empty parameter lists, e.g.:

```c
int sum(int a, int b);
float avg(int x, float y) {
	return x + y;
}
```

### 2.4 Statements

Supported statements:

-   Empty statement (`;`)
-   Variable declaration
-   Assignment
-   `return`
-   Compound/block
-   Conditionals
-   Loops
-   `break` and `continue`

### 2.5 Expressions

Expressions support:

-   Arithmetic: `+ - * /`
-   Relational: `< > <= >= == !=`
-   Logical: `&& || !`
-   Unary inc/dec: `++ --`
-   Assignment and compound assignment: `= += -= *= /=`
-   Parenthesized expressions

Operator precedence and associativity are encoded in the grammar.

## 3. Lexical Analyzer (flex)

### 3.1 Token Recognition

The lexer recognizes:

-   Keywords: `int`, `float`, `void`, `if`, `else`, `while`, `do`, `for`, `return`, `break`, `continue`
-   Identifiers: alphanumeric/underscore names starting with a letter or underscore
-   Literals: integer, floating-point, and string literals
-   Operators and delimiters: arithmetic, logical, relational, assignment operators, parentheses, braces, commas, semicolons

### 3.2 Lexer Behavior

-   Whitespace and newlines are ignored
-   Line numbers tracked via `%option yylineno`
-   Unknown characters reported with descriptive errors
-   Tokens returned with semantic values where applicable

## 4. Parser (bison)

### 4.1 Grammar Structure

The grammar covers program structure, statement lists, expression precedence, conditionals, loops, and error recovery. Ambiguity such as the dangling `else` is resolved via matched/unmatched statement rules.

### 4.2 Error Handling

Uses bison`s `error`token, custom messages, line reporting, and`yyerrok` for controlled recovery. Example:

```
Line 12 near ')': Malformed parameter list in function definition
```

## 5. Development Methodology and Testing

### 5.1 Incremental Development with Git

Features added and tested in stages: basic functions → parameters → statements → expressions → control flow.

### 5.2 Testing Strategy

-   Incremental tests per feature
-   Dedicated valid/invalid programs
-   Current sample inputs live in the `tests/` directory:
    -   [tests/test01_minimal.mc](tests/test01_minimal.mc)
    -   [tests/test02_function_params.mc](tests/test02_function_params.mc)
    -   [tests/test03_variables.mc](tests/test03_variables.mc)
    -   [tests/test04_expressions.mc](tests/test04_expressions.mc)
    -   [tests/test05_if_else.mc](tests/test05_if_else.mc)
    -   [tests/test06_dangling_else.mc](tests/test06_dangling_else.mc)
    -   [tests/test07_while.mc](tests/test07_while.mc)
    -   [tests/test08_do_while.mc](tests/test08_do_while.mc)
    -   [tests/test09_for.mc](tests/test09_for.mc)
    -   [tests/test10_break.mc](tests/test10_break.mc)
    -   [tests/test11*function_call.mc*](tests/test11_function_call.mc_)
    -   [tests/test12*string.mc*](tests/test12_string.mc_)
    -   [tests/test13_missing_semicolon.mc](tests/test13_missing_semicolon.mc)
    -   [tests/test14_bad_params.mc](tests/test14_bad_params.mc)
    -   [tests/test15_invalid_expressions.mc](tests/test15_invalid_expressions.mc)
    -   [tests/test16_unmatched_brace.mc](tests/test16_unmatched_brace.mc)
    -   [tests/test17_unknown_char.mc](tests/test17_unknown_char.mc)

```c
int main() {
	int x;
	x = 10;
	if (x > 5) {
		x++;
	}
}
```

Example invalid input:

```c
int main( {
	x = ;
}
```

The parser accepts valid code and reports syntax errors for invalid constructs.

### 5.3 Running the Parser

Build the project (using `make` or your preferred build command), then feed a test file to the parser:

```bash
./parser < tests/test07_while.mc
```

Replace `tests/test07_while.mc` with any input file under `tests/` to run the other incremental cases.
