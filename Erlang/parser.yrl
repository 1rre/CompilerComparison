Nonterminals
  program add_sub div_mul lines line eol decl value.
Terminals
  identifier object extends int intliteral val app return
  '+' '-' '/' '*' '%' '(' ')' '{' '}' '=' ';'.

Rootsymbol program.

Left 100 add_sub.
Left 200 div_mul.

program -> object identifier extends app '{' lines '}' : '$6'.

eol -> ';' : eol.

lines -> line eol lines : ['$1'|'$3'].
lines -> line eol       : ['$1'].
lines -> line           : ['$1'].

line -> identifier '(' value ')' : {'$1', '$3'}.
line -> val decl '=' value       : {decl, '$2', '$4'}.
line -> return value             : {return, '$2'}.

decl -> identifier         : '$1'.

add_sub -> '+' : {op, '+'}.
add_sub -> '-' : {op, '-'}.

div_mul -> '*' : {op, '*'}.
div_mul -> '/' : {op, '/'}.
div_mul -> '%' : {op, '%'}.

value -> intliteral          : '$1'.
value -> identifier          : '$1'.
value -> '(' value ')'       : '$2'.
value -> value add_sub value : {'$2', '$1', '$3'}.
value -> value div_mul value : {'$2', '$1', '$3'}.
