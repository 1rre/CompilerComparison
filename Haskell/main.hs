import Text.ParserCombinators.Parsec

eol :: GenParser Char st Char
eol = char ';'

wsreq :: GenParser Char st [Char]
wsreq = many1 space
wsopt :: GenParser Char st [Char]
wsopt = many space

idCharInit :: GenParser Char st Char
idCharInit = choice [letter, char '_']

idChar :: GenParser Char st Char
idChar = choice [idCharInit, digit]

name :: GenParser Char st [Char]
name = do
  many space
  first <- idCharInit
  rest <- many idChar
  notFollowedBy idChar
  return (first:rest)

reqws :: GenParser Char st a -> GenParser Char st a
reqws parsec = do
  many space
  parsec

optws :: GenParser Char st a -> GenParser Char st a
optws parsec = reqws parsec <|> parsec

intliteral :: GenParser Char st [Char]
intliteral = optws (many1 digit)

bracketedExpr :: GenParser Char st [Char]
bracketedExpr = do
  optws (char '(')
  x <- expr
  optws (char ')')
  return x

baseExpr :: GenParser Char st [Char]
baseExpr =  choice [intliteral, bracketedExpr, name]

divMul :: GenParser Char st [Char]
divMul = do
  x1 <- optws baseExpr
  op <- optws (oneOf "*/%")
  x2 <- optws (try divMul <|> baseExpr)
  return ("(" ++ x1 ++ [op] ++ x2 ++ ")")

addSub :: GenParser Char st [Char]
addSub = do
  x1 <- optws (try divMul <|> baseExpr)
  op <- optws (oneOf "+-")
  x2 <- optws expr
  return ("(" ++ x1 ++ [op] ++ x2 ++ ")")

expr :: GenParser Char st [Char]
expr = try addSub <|> try divMul <|> baseExpr

valDecl :: GenParser Char st [Char]
valDecl = do
  optws (string "val")
  identifier <- reqws name
  optws (string "=")
  value <- optws expr
  return ("int " ++ identifier ++ " = " ++ value)

println :: GenParser Char st [Char]
println = do
  optws (string "println")
  optws (char '(')
  toPrint <- expr
  optws (char ')')
  return toPrint

returnStatement :: GenParser Char st [Char]
returnStatement = do
  optws (string "return")
  expr

line :: GenParser Char st [Char]
line = do
  ln <- try valDecl <|> try println <|> returnStatement
  optws (char ';')
  spaces
  return (ln ++ ";\n")

mainFun :: GenParser Char st [[Char]]
mainFun = do
  optws (string "object")
  reqws name
  reqws (string "extends")
  reqws (string "App")
  optws (char '{')
  st <- many (optws line)
  optws (char '}')
  optws eof
  return st

formatLine :: [[Char]] -> [[Char]]
formatLine = map ("  " ++)

formatOutput :: Either ParseError [[Char]] -> [Char]
formatOutput (Right output) = do
  let x = foldl1 (++) (formatLine output)
  "int main() {\n" ++ x ++ "}\n"
formatOutput (Left error) = do
  "error:\n" ++ show error

main :: IO ()
main = do
  let inputStr = ["object Main extends App {\n",
                  "  val y = (5 + 3) * 5;\n",
                  "  val x = 10;\n", "  println(x + y);\n",
                  "  return x + y * 2;\n",
                  "}\n"]
  let input = foldl1 (++) inputStr
  let result = formatOutput (parse mainFun "unknown" input)
  putStrLn result
