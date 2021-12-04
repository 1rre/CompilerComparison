to(A,A,[A]) :- !.
to(A,B,[A|C]) :-
  B >= A,
  D is A + 1,
  to(D,B,C).
lower(X) :-
  to(97, 122, L),
  member(X, L).
upper(X) :-
  to(65, 90, L),
  member(X, L).
digit(X) :-
  to(48, 57, L),
  member(X, L).
ident_init_char(X) :- upper(X).
ident_init_char(X) :- lower(X).
ident_init_char('_').

ident_char(X) :- ident_init_char(X).
ident_char(X) :- digit(X).

all_ident_chars([]).
all_ident_chars([Hd|Tl]) :-
  ident_char(Hd),
  all_ident_chars(Tl).

ident([Ch|Tl]) :-
  ident_init_char(Ch),
  all_ident_chars(Tl).

intliteral([X]) :- digit(X).
intliteral([Hd|Tl]) :- digit(Hd), intliteral(Tl).

whitespace(9).
whitespace(10).
whitespace(11).
whitespace(32).

ws_opt([]).
ws_opt([Hd|Tl]) :- whitespace(Hd), ws_opt(Tl).
ws_req([Hd|Tl]) :- whitespace(Hd), ws_opt(Tl).


main_decl(A) :-
  append("object", NoObj, A),
  append(WsObj, NoWsObj, NoObj),
  ws_req(WsObj),
  append(Ident, NoIdent, NoWsObj),
  ident(Ident),
  NoIdent = "".

compile(In, Out) :-
  append(X, Out, In),
  main_decl(X).

