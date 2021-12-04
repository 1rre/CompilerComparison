Definitions.

WHITESPACE = [\s\n]+
IDENT = [_a-zA-Z0-9]+
VALKEYWORD = val
EOL = [\n]+
INTLITERAL = [0-9]+
SYMBOL = [=+\-\/*%{}();]
OBJECT = object
EXTENDS = extends
RETURN = return
APP = App


Rules.
{INTLITERAL} : {token, {intliteral, TokenLine, TokenChars}}.
{VALKEYWORD} : {token, {val, TokenLine}}.
{OBJECT}     : {token, {object, TokenLine}}.
{EXTENDS}    : {token, {extends, TokenLine}}.
{RETURN}     : {token, {return, TokenLine}}.
{APP}        : {token, {app, TokenLine}}.
{IDENT}      : {token, {identifier, TokenLine, TokenChars}}.
{SYMBOL}     : {token, {list_to_atom(TokenChars), TokenLine}}.
{WHITESPACE} : skip_token.

Erlang code.
% Any Erlang code goes here - we don't need any for something this simple.
