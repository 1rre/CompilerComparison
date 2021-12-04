-module(complier).
-export([main/1]).

main(_Args) ->
  Input = (
    "object Main extends App {\n" ++
    "  val y = (5 + 3) * 5;\n" ++
    "  val x = 10;\n" ++
    "  println(x + y);\n" ++
    "  return x + y * 2;\n" ++
    "}"
  ),
  leex:file(lexer),
  c:c(lexer),
  c:y(parser),
  c:c(parser),
  {ok, Tokens, _} = lexer:string(Input),
  {ok, ParseResult} = parser:parse(Tokens),
  COutput = transform(ParseResult),
  io:fwrite("int main() {~n~s}~n", [COutput]).

transform([Hd|Tl]) ->
  {ok, String} = transform1(Hd),
  String ++ transform(Tl);
transform([]) -> [].

transform1({decl, {identifier, _Line, Name}, Value}) ->
  Initial = getValue(Value),
  {ok, io_lib:format("  int ~s = ~s;~n", [Name, Initial])};
transform1({{identifier, _, "println"}, Value}) ->
  ToPrint = getValue(Value),
  {ok, io_lib:format("  printf(\"%d\\n\", ~s);~n", [ToPrint])};
transform1({return, Value}) ->
  Return = getValue(Value),
  {ok, io_lib:format("  return ~s;~n", [Return])}.

getValue({intliteral, _Line, Value}) -> Value;
getValue({identifier, _Line, Name}) -> Name;
getValue({{op, Op}, X1, X2}) ->
  X1Value = getValue(X1),
  X2Value = getValue(X2),
  io_lib:format("(~s ~s ~s)", [X1Value, Op, X2Value]).
